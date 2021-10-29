/*
Developed by Zachary Selk at the University of Alberta (zrselk@gmail.com)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject
to the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

(MIT license, http://www.opensource.org/licenses/mit-license.html)
*/

package rars.tools;

import rars.Globals;
import rars.riscv.hardware.*;

import java.util.*;

import javax.swing.*;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.datatransfer.StringSelection;
import java.awt.Toolkit;
import java.awt.datatransfer.Clipboard;



/**
 * A RARS tool for playing a Virtual Piano
 *
 * Builds on https://github.com/TheThirdOne/rars.git
 *
 * @author Fabian Schneider
 */


public class VirtualPiano extends AbstractToolAndApplication {

    private static final String heading = "Virtual Piano";
    private static final String version = "Version 1.0";

    //Offset for data segment
    private int offset = 0;
    //Needed for calculating the free storage in data segment
    private int usedData = 0;

    //////////////////////////////////////////////////////
    //Major GUI Components

    /**
     * The upper part contains basic functionalities such as redefining the volume,
     * duration and used Instrument at runtime. Extra functionalities are given by
     * allowing to record, play and save the played melody.
     */
    private JPanel selectionArea;
    //Record - Play - Save
    private JButton recordButton;
    private JButton playButton;
    private JButton saveButton;
    private JButton gameButton;
    //Combobox for selecting an Instrument
    private JComboBox<String> instrumentSelection;
    //Volume Slider
    private JSlider volumeSlider;
    private JSlider durationSlider;

    /**
     * This is the center section in which all piano keys and shift keys are placed. The shift
     * key allows to play in a higher or lower pitch. Using a shift button once, results in a
     * pitch higher or lower by one octave.
     */
    JPanel keyArea = new JPanel();
    //All Piano Keys
    private JButton cButton;
    private JButton cSharpButton;
    private JButton dButton;
    private JButton dSharpButton;
    private JButton eButton;
    private JButton fButton;
    private JButton fSharpButton;
    private JButton gButton;
    private JButton gSharpButton;
    private JButton aButton;
    private JButton aSharpButton;
    private JButton bButton;

    //Buttons Shifting pitches Higher and Lower
    private JButton shiftLeftButton;
    private JButton shiftRightButton;

    //Section for the Memory percentage bar
    private JProgressBar availableMemory;
    private JPanel bottomSection;


    //Default-Pitches
    private int pitchList[] = {
            0x0000003C, //C Pitch
            0x0000003D, //C#/Db Pitch
            0x0000003E, //D Pitch
            0x0000003F, //D#/Eb Pitch
            0x00000040, //E Pitch
            0x00000041, //F Pitch
            0x00000042, //F#/Gb Pitch
            0x00000043, //G Pitch
            0x00000044, //G#/Ab Pitch
            0x00000045, //A Pitch
            0x00000046, //A#/Bb Pitch
            0x00000047  //B Pitch
    };

    /**
     * These Values have to be used as a reference, when values of the pitchList are been shifted
     * too low or too high. The minimum and maximum value is given by the MidiOutSync sycall
     */
    private static final int[] restoreValues = {0x0000003C, 0x0000003D,  0x0000003E, 0x0000003F, 0x00000040,
            0x00000041, 0x00000042, 0x00000043, 0x00000044, 0x00000045, 0x00000046, 0x00000047};

    private static final int MAXOCTAVE = 120;
    private static final int MINOCTAVE = 12;

    //Octave Higher - Octave Lower
    private static final int RIGHTSHIFT = 0;
    private static final int LEFTSHIFT = 1;

    /**
     * Instruments defined as string are needed for the combobox. The integer value will be used to write in the
     * register when being selected. The values are predefined by the MidiOutSync sycall.
     */
    private static final String[] instrumentNames = {"Piano", "Chromatic Percussion", "Organ", "Guitar",
            "Bass", "Strings", "Ensemble", "Brass", "Reed", "Pipe", "Synth Lead", "Synth Pad", "Synth Effect",
            "Ethnic", "Percussion"};

    private static final int[] instrumentValues = {
            0x00000000, //Piano
            10, //Chromatic Percussion
            18, //Organ
            24, //Guitar
            0x00000020, //Bass
            0x00000028, //Strings
            0x00000030, //Ensemble
            0x00000038, //Brass
            0x00000040, //Reed
            0x00000048, //Pipe
            0x00000050, //Synth Lead
            0x00000058, //Synth Pad
            0x00000060, //Synth Effect
            0x00000068, //Ethnic
            0x00000070, //Percussion
            0x00000078, //Sound Effect
    };

    private boolean record = false;
    private boolean playMode = false;

    //Storing pitches when recorded for saving method
    java.util.List<Integer> recorded = new ArrayList<Integer>();

    ///////////////////////////////////////
    //Basic Methods

    /**
     * Combobox should show the correct instrument if the defined value in a2 in asm file is matching a value of the
     * instrumentValues array
     * @return -1 if no instrument can be matched
     */
    private int setSelectedInstrument() {
        int currentInstrument = RegisterFile.getValue("a2");
        for(int i = 0; i < instrumentValues.length; i++) {
            if(instrumentValues[i] == currentInstrument) {
                return i;
            }
        }
        return -1;
    }

    /**
     * A pitch event is triggered by each key button in the center section. If a record session takes place
     * then add the triggered key to the recorded list for saving functionality
     * @param pitch is used from the pitchList
     */
    private void pitchEvent(int pitch) {
        RegisterFile.updateRegister("a0", pitch);
        try
        {
            if(RegisterFile.getValue("a2") != -1) {
                //Sleep prevents the clear coming too soon (Otherwise pitch wouldn't be played at all)
                Thread.sleep(100);
                //Needs to be reset to not play the same pitch multiple times
                RegisterFile.updateRegister("a0", 0);
            }
            if(record)
            {
                recorded.add(pitch);
            }
        }
        catch(InterruptedException ex)
        {
            Thread.currentThread().interrupt();
        }
    }

    /**
     *Shifts all pitches either by the value 0x000000C depending on the shift direction. Jumping back to
     *default values when arrived at minimum or maximum pitch
     * @param shiftDirection either one octave higher or lower
     */
    private void shiftOctave(int shiftDirection) {
        if(shiftDirection == LEFTSHIFT) {
            for(int i = 0; i < pitchList.length; i++)
                //When arrived at minimum octave then jump to default octave
                if(pitchList[i] < MINOCTAVE)
                    pitchList[i] = restoreValues[i];
                else
                    pitchList[i] = pitchList[i] - 0x000000C;

        }
        else if (shiftDirection == RIGHTSHIFT) {
            for (int i = 0; i < pitchList.length; i++)
                //When arrived at maximum octave then jump to default octave
                if(pitchList[i] >= MAXOCTAVE)
                    pitchList[i] = restoreValues[i];
                else
                    pitchList[i] = pitchList[i] + 0x000000C;
        }
    }

    /**
     * Data Segment (used as the storage when recording takes place) should be set to default when
     * reset Button declared in AbstractToolAndApplication class is pressed.
     */
    private void resetDataSegment() {
        usedData = 0;
        offset = 0;
        RegisterFile.updateRegister("a0", 0x00000000);
        availableMemory.setValue(usedData);
        for(int i = 0; i < 512; i += 4) {
            try {
                Globals.memory.setWord(Memory.dataBaseAddress + i, 0x00000000);
            } catch (AddressErrorException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Every value written in the data segment is played until a zero/unwritten cell is detected or
     * data segments end address has been reached. Next address can be read by adding a value of +4 to the
     * prior address
     * @throws AddressErrorException
     */
    private void playRecording() throws AddressErrorException {
        usedData = 0;
        int counter = 0;
        do {
            try {
                int tmpPitch = Globals.memory.getWord(Memory.dataBaseAddress + counter);
                RegisterFile.updateRegister("a0", tmpPitch);
                Thread.sleep(RegisterFile.getValue("a1"));
                //move one cell forward
                counter += 4;

            } catch (AddressErrorException | InterruptedException a) {
                a.printStackTrace();
            }
            //data segment contains 128 cells (4 * 128 = 512 = end address)
        } while((Globals.memory.getWord(Memory.dataBaseAddress + counter)) != 0 && counter < 512);
        //Needs to be reset to not play the last pitch multiple times again after melody has been actually finished playing
        RegisterFile.updateRegister("a0", 0x00000000);
    }

    /**
     * Method stops the recording session and allows playing without writing in the data segment.
     * After pressing record button again the record session continues (linking to prior recording
     * if reset button hasn't been used)
     */
    private void interruptRecording() {
        recordButton.setText("record");
        record = false;
    }

    /**
     * Fills the percentage bar depending on the available space in the data segment.
     */
    private void fillPercentageBar() {
        usedData++;
        availableMemory.setValue(usedData);
    }

    /**
     * Overrides the method without any functionality of the AbstractToolAndApplication class.
     * Will be called when the reset button is pressed and clears complete data segment
     */
    @Override
    protected void reset() {
        resetDataSegment();
        super.reset();
    }

    /**
     * Necessary for playing the mini-game
     */
    private void changeKeyColor() {
        cButton.setBackground(Color.decode("#FF0000"));
        cSharpButton.setBackground(Color.decode("#FF9E00"));
        dButton.setBackground(Color.decode("#FFFB00"));
        dSharpButton.setBackground(Color.decode("#90FF00"));
        eButton.setBackground(Color.decode("#05FF00"));
        fButton.setBackground(Color.decode("#00FFDE"));
        fSharpButton.setBackground(Color.decode("#0099FF"));
        gButton.setBackground(Color.decode("#001AFF"));
        gSharpButton.setBackground(Color.decode("#9000FF"));
        aButton.setBackground(Color.decode("#F800FF"));
        aSharpButton.setBackground(Color.decode("#FF007B"));
        bButton.setBackground(Color.decode("#FF0000"));
    }

    ///////////////////////////////////////////////
    //Main GUI Sections

    /**
     * Builds the top section which includes multiple setting possibilities.
     * @return selectionArea
     */
    private JComponent buildSelectionArea()
    {

        selectionArea = new JPanel();
        //Buttons for selecting mode
        recordButton = new JButton("record");
        playButton = new JButton("play");
        saveButton = new JButton("save");
        //Combobox for selecting an instrument
        instrumentSelection = new JComboBox<String>(instrumentNames);
        //Sliders to set volume and duration
        volumeSlider = new JSlider(JSlider.HORIZONTAL, 0, 127, RegisterFile.getValue("a3"));
        durationSlider = new JSlider(JSlider.HORIZONTAL, 0, 3000, RegisterFile.getValue("a1"));


        volumeSlider.setToolTipText("Volume");
        durationSlider.setToolTipText("Duration");

        /**
         * Record will be set to true. Afterwards all played pitches are stored in an array (in data segment).
         * If the record button was pressed before, it now functions as a stop button for interrupting the recording.
         */
        recordButton.addActionListener(
                new ActionListener() {
                    public void actionPerformed(ActionEvent e) {
                        //Check if record button is already pressed or not
                        if(connectButton.isConnected() && !record) {
                            recordButton.setText("stop");
                            record = true;
                        }
                        else
                            interruptRecording();
                    }
                });

        /**
         * Stops the recording and starts playing the pitch sequence by calling playRecording method.
         */
        playButton.addActionListener(
                new ActionListener() {
                    public void actionPerformed(ActionEvent e) {
                        try {
                            //stops recording automatically
                            interruptRecording();
                            playRecording();
                        } catch (AddressErrorException ex) {
                            ex.printStackTrace();
                        }
                    }
                });

        /**
         * An automatically generated assembly code which plays the melody.
         * The sequence of the pitches are stored as an array.
         */
        saveButton.addActionListener(
                new ActionListener() {
                    public void actionPerformed(ActionEvent e) {
                        //Stops recording automatically
                        interruptRecording();
                        //prints the assembly code
                        String asmCode = ".data\nmelody:\n.word ";
                        for(int i = 0; i < recorded.size(); i++)
                            asmCode += recorded.get(i).toString() + " ";

                        asmCode += "\n\n.text\ninitialize:\n" +
                                "li a7, 33\n" +
                                "li a1, " + RegisterFile.getValue("a1") +
                                "\nli a2, " + RegisterFile.getValue("a2") +
                                "\nli a3, " + RegisterFile.getValue("a3") +
                                "\nla a4, melody\n" +
                                "li t0, 0 \n" +
                                "li t1, " + ((recorded.size() * 4) - 4) +
                                "\n" +
                                "\nmain:\n" +
                                "bge t1, t0, playMelody\n" +
                                "j exit #if t1 = t0 exit\n" +
                                "\nplayMelody:\n" +
                                "lw a0, 0(a4) #load word from array\n" +
                                "addi t0, t0, 4 #i++\n" +
                                "addi a4, a4, 4 #array go one position forward\n" +
                                "ecall \n" +
                                "j main\n" +
                                "\n" +
                                "exit:\n" +
                                "addi zero, zero, 0";

                        //GUI settings of pop up
                        JTextArea codeArea = new JTextArea(asmCode);
                        codeArea.setRows(20);
                        codeArea.setColumns(30);
                        codeArea.setLineWrap(true);
                        codeArea.setWrapStyleWord(true);
                        JOptionPane.showMessageDialog(theWindow, new JScrollPane(codeArea),
                                "Insert in a new .asm File (Code is copied to Clipboard)", JOptionPane.INFORMATION_MESSAGE);
                        StringSelection stringSelection = new StringSelection(asmCode);
                        Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
                        clipboard.setContents(stringSelection, null);
                    }
                });

        /**
         * Changes the value of register a3 (volume of each pitch). If a value for volume register
         * has been defined in asm file, then the slider value is placed at the correct position.
         */
        volumeSlider.addChangeListener(new ChangeListener() {
            @Override
            public void stateChanged(ChangeEvent e) {
                //needed for updating the slider position automatically
                JSlider source = (JSlider)e.getSource();
                RegisterFile.updateRegister("a3", source.getValue());
            }
        });

        /**
         * Changes the value of register a1 (duration of each pitch). If a value for duration register
         * has been defined in asm file, then the slide rvalue is placed at the correct position.
         */
        durationSlider.addChangeListener(new ChangeListener() {
            @Override
            public void stateChanged(ChangeEvent e) {
                //needed for updating the slider position automatically
                JSlider source = (JSlider)e.getSource();
                RegisterFile.updateRegister("a1", source.getValue());
            }
        });

        /**
         * Changes the value of register a2 (sound of instrument for each pitch). Uses the values of the
         * instrumentSelection array.
         */
        instrumentSelection.addActionListener(
                new ActionListener() {
                    public void actionPerformed(ActionEvent e) {
                        RegisterFile.updateRegister("a2", instrumentSelection.getSelectedIndex());
                    }
                });

        /**
         * Updates the checkbox if the defined instrument in asm file is equal to one in the instrumentSelection array.
         */
        //-1 if no instrument could be matched
        if(setSelectedInstrument() != -1)
            instrumentSelection.setSelectedIndex(setSelectedInstrument());

        /**
         * Adds all GUI components to the top area.
         */
        selectionArea.add(recordButton);
        selectionArea.add(playButton);
        selectionArea.add(saveButton);
        selectionArea.add(new JLabel("Duration "), BorderLayout.WEST);
        selectionArea.add(durationSlider);
        selectionArea.add(new JLabel("Volume "), BorderLayout.WEST);
        selectionArea.add(volumeSlider);
        selectionArea.add(instrumentSelection);

        return selectionArea;
    }

    /**
     * Builds the middle area. Includes all piano keys and shift keys for shifting the pitches one octave
     * up or down.
     * @return keyArea
     */
    private JComponent buildKeyArea()
    {

        JPanel keyArea = new JPanel();

        //add piano keys
        cButton = new JButton("C");
        cSharpButton = new JButton("C#");
        dButton = new JButton("D");
        dSharpButton = new JButton("D#");
        eButton = new JButton("E");
        fButton = new JButton("F");
        fSharpButton = new JButton("F#");
        gButton = new JButton("G");
        gSharpButton = new JButton("G#");
        aButton = new JButton("A");
        aSharpButton = new JButton("A#");
        bButton = new JButton("B");

        //shift Buttons
        shiftLeftButton = new JButton("<");
        shiftRightButton = new JButton(">");

        //GUI settings for all buttons in middle area
        shiftRightButton.setPreferredSize(new Dimension(58, 160));
        cButton.setPreferredSize(new Dimension(58, 160));
        cSharpButton.setPreferredSize(new Dimension(58, 160));
        dButton.setPreferredSize(new Dimension(58, 160));
        dSharpButton.setPreferredSize(new Dimension(58, 160));
        eButton.setPreferredSize(new Dimension(58, 160));
        fButton.setPreferredSize(new Dimension(58, 160));
        fSharpButton.setPreferredSize(new Dimension(58, 160));
        gButton.setPreferredSize(new Dimension(58, 160));
        gSharpButton.setPreferredSize(new Dimension(58, 160));
        aButton.setPreferredSize(new Dimension(58, 160));
        aSharpButton.setPreferredSize(new Dimension(58, 160));
        bButton.setPreferredSize(new Dimension(58, 160));
        shiftLeftButton.setPreferredSize(new Dimension(58, 160));

        //Display them in middle area
        keyArea.add(shiftLeftButton);
        keyArea.add(cButton);
        keyArea.add(cSharpButton);
        keyArea.add(dButton);
        keyArea.add(dSharpButton);
        keyArea.add(eButton);
        keyArea.add(fButton);
        keyArea.add(fSharpButton);
        keyArea.add(gButton);
        keyArea.add(gSharpButton);
        keyArea.add(aButton);
        keyArea.add(aSharpButton);
        keyArea.add(bButton);
        keyArea.add(shiftRightButton);

        /**
         * By pressing a piano key button the correct value for register a0 will be set through the with the
         * pitchEvent method. If a record session takes place, then the pitch value will also be saved in data segment,
         * and fill the percentage bar for displaying the amount of memory is used
         */
        cButton.addActionListener(
                new ActionListener() {
                    public void actionPerformed(ActionEvent e) {
                        try {
                            if(!record)
                                //calling the pitchEvent with correct pitch value in pitchList
                                pitchEvent(pitchList[0]);
                            else {
                                pitchEvent(pitchList[0]);
                                //save the pitch value in data segment
                                Globals.memory.setWord(Memory.dataBaseAddress + offset, pitchList[0]);
                                //move one address in data segment further
                                offset += 4;
                                fillPercentageBar();
                            }
                        } catch (AddressErrorException ex) {
                            ex.printStackTrace();
                        }
                    }
                });

        cSharpButton.addActionListener(
                new ActionListener() {
                    public void actionPerformed(ActionEvent e) {
                        try {
                            if(!record)
                                pitchEvent(pitchList[1]);
                            else {
                                pitchEvent(pitchList[1]);
                                Globals.memory.setWord(Memory.dataBaseAddress + offset, pitchList[1]);
                                offset += 4;
                                fillPercentageBar();
                            }
                        } catch (AddressErrorException ex) {
                            ex.printStackTrace();
                        }
                    }
                });

        dButton.addActionListener(
                new ActionListener() {
                    public void actionPerformed(ActionEvent e) {
                        try {
                            if(!record)
                                pitchEvent(pitchList[2]);
                            else {
                                pitchEvent(pitchList[2]);
                                Globals.memory.setWord(Memory.dataBaseAddress + offset, pitchList[2]);
                                offset += 4;
                                fillPercentageBar();
                            }
                        } catch (AddressErrorException ex) {
                            ex.printStackTrace();
                        }
                    }
                });

        dSharpButton.addActionListener(
                new ActionListener() {
                    public void actionPerformed(ActionEvent e) {
                        try {
                            if(!record)
                                pitchEvent(pitchList[3]);
                            else {
                                pitchEvent(pitchList[3]);
                                Globals.memory.setWord(Memory.dataBaseAddress + offset, pitchList[3]);
                                offset += 4;
                                fillPercentageBar();
                            }
                        } catch (AddressErrorException ex) {
                            ex.printStackTrace();
                        }
                    }
                });

        eButton.addActionListener(
                new ActionListener() {
                    public void actionPerformed(ActionEvent e) {
                        try {
                            if(!record)
                                pitchEvent(pitchList[4]);
                            else {
                                pitchEvent(pitchList[4]);
                                Globals.memory.setWord(Memory.dataBaseAddress + offset, pitchList[4]);
                                offset += 4;
                                fillPercentageBar();
                            }
                        } catch (AddressErrorException ex) {
                            ex.printStackTrace();
                        }
                    }
                });

        fButton.addActionListener(
                new ActionListener() {
                    public void actionPerformed(ActionEvent e) {
                        try {
                            if(!record)
                                pitchEvent(pitchList[5]);
                            else {
                                pitchEvent(pitchList[5]);
                                Globals.memory.setWord(Memory.dataBaseAddress + offset, pitchList[5]);
                                offset += 4;
                                fillPercentageBar();
                            }
                        } catch (AddressErrorException ex) {
                            ex.printStackTrace();
                        }
                    }
                });

        fSharpButton.addActionListener(
                new ActionListener() {
                    public void actionPerformed(ActionEvent e) {
                        try {
                            if(!record)
                                pitchEvent(pitchList[6]);
                            else {
                                pitchEvent(pitchList[6]);
                                Globals.memory.setWord(Memory.dataBaseAddress + offset, pitchList[6]);
                                offset += 4;
                                fillPercentageBar();
                            }
                        } catch (AddressErrorException ex) {
                            ex.printStackTrace();
                        }
                    }
                });

        gButton.addActionListener(
                new ActionListener() {
                    public void actionPerformed(ActionEvent e) {
                        try {
                            if(!record)
                                pitchEvent(pitchList[7]);
                            else {
                                pitchEvent(pitchList[7]);
                                Globals.memory.setWord(Memory.dataBaseAddress + offset, pitchList[7]);
                                offset += 4;
                                fillPercentageBar();
                            }
                        } catch (AddressErrorException ex) {
                            ex.printStackTrace();
                        }
                    }
                });

        gSharpButton.addActionListener(
                new ActionListener() {
                    public void actionPerformed(ActionEvent e) {
                        try {
                            if(!record)
                                pitchEvent(pitchList[8]);
                            else {
                                pitchEvent(pitchList[8]);
                                Globals.memory.setWord(Memory.dataBaseAddress + offset, pitchList[8]);
                                offset += 4;
                                fillPercentageBar();
                            }
                        } catch (AddressErrorException ex) {
                            ex.printStackTrace();
                        }
                    }
                });

        aButton.addActionListener(
                new ActionListener() {
                    public void actionPerformed(ActionEvent e) {
                        try {
                            if(!record)
                                pitchEvent(pitchList[9]);
                            else {
                                pitchEvent(pitchList[9]);
                                Globals.memory.setWord(Memory.dataBaseAddress + offset, pitchList[9]);
                                offset += 4;
                                fillPercentageBar();
                            }
                        } catch (AddressErrorException ex) {
                            ex.printStackTrace();
                        }
                    }
                });

        aSharpButton.addActionListener(
                new ActionListener() {
                    public void actionPerformed(ActionEvent e) {
                        try {
                            if(!record)
                                pitchEvent(pitchList[10]);
                            else {
                                pitchEvent(pitchList[10]);
                                Globals.memory.setWord(Memory.dataBaseAddress + offset, pitchList[10]);
                                offset += 4;
                                fillPercentageBar();
                            }
                        } catch (AddressErrorException ex) {
                            ex.printStackTrace();
                        }
                    }
                });

        bButton.addActionListener(
                new ActionListener() {
                    public void actionPerformed(ActionEvent e) {
                        try {
                            if(!record)
                                pitchEvent(pitchList[11]);
                            else {
                                pitchEvent(pitchList[11]);
                                Globals.memory.setWord(Memory.dataBaseAddress + offset, pitchList[11]);
                                offset += 4;
                                fillPercentageBar();
                            }
                        } catch (AddressErrorException ex) {
                            ex.printStackTrace();
                        }
                    }
                });

        /**
         * Shift button add or subtract all pitch values with 12 for going one octave higher or lower
         */
        //Left shift subtracts 12 from each pitch
        shiftLeftButton.addActionListener(
                new ActionListener() {
                    public void actionPerformed(ActionEvent e) {
                        shiftOctave(LEFTSHIFT);
                    }
                }
        );

        //Right shift adds 12 to each pitch
        shiftRightButton.addActionListener(
                new ActionListener() {
                    public void actionPerformed(ActionEvent e) {
                        shiftOctave(RIGHTSHIFT);
                    }
                }
        );

        return keyArea;
    }

    /**
     * Last row includes button for starting the game mode. game modes simply changes the colors of the piano keys
     * for making the mini-game easier. The progressbar shows how much memory is left in data segment
     * @return bottomSection
     */
    private JComponent buildBottomArea()
    {
        bottomSection = new JPanel();

        gameButton = new JButton("game");
        gameButton.addActionListener(
                new ActionListener() {
                    public void actionPerformed(ActionEvent e) {
                        playMode = true;
                        changeKeyColor();
                    }
                });
        //Progressbar for showing how much memory data segment is used when doing a record session
        availableMemory = new JProgressBar(JProgressBar.HORIZONTAL, 0, 128);
        //GUI settings for
        availableMemory.setStringPainted(true);
        availableMemory.setForeground(Color.RED);
        availableMemory.setBackground(Color.WHITE);

        bottomSection.add(gameButton);
        bottomSection.add(new JLabel("Used Memory "), BorderLayout.WEST);
        bottomSection.add(availableMemory);

        return bottomSection;
    }

    /**
     * Adds all sections the mainframe of the Virtual Piano GUI
     * @return mainframe
     */
    protected JComponent buildMainDisplayArea() {

        JPanel mainFrame = new JPanel();
        mainFrame.setLayout(new BorderLayout());

        mainFrame.add(buildSelectionArea(), BorderLayout.PAGE_START);
        mainFrame.add(buildKeyArea(), BorderLayout.CENTER);
        mainFrame.add(buildBottomArea(), BorderLayout.PAGE_END);

        return mainFrame;
    }

    /**
     * Help window includes a possible assembly code, which can be used for playing the Virtual Piano.
     * Identical to the assembly code in Github Repository ("start.asm")
     * @return help
     */
    protected JComponent getHelpComponent() {
        final String helpMessage =
                "The Virtual Piano is based on the MidiOutSync Sycall. Therefor its crucial to set Register a7 to " +
                        "33 and invoke ecall through a loop. Other Registers can be set in Runtime with the GUI\n" +
                        "possible code for playing the virtual piano: \n" +
                        "##############################\n"+

                        "initialize:\n" +
                        "li a7, 33\n" +
                        "li a1, 500\n" +
                        "li a2, 8\n" +
                        "li a3, 80\n" +
                        "\n" +
                        "main:\n" +
                        "bnez a0, playSound \n" +
                        "j main\n" +
                        "\n" +
                        "playSound:\n" +
                        "ecall\n" +
                        "j main\n" +

                        "#############################";
        JButton help = new JButton("Help");
        help.addActionListener(
                new ActionListener() {
                    public void actionPerformed(ActionEvent e) {
                        JTextArea helpContent = new JTextArea(helpMessage);
                        helpContent.setRows(20);
                        helpContent.setColumns(30);
                        helpContent.setLineWrap(true);
                        helpContent.setWrapStyleWord(true);
                        theWindow.add(helpContent);
                        JOptionPane.showMessageDialog(theWindow,  new JScrollPane(helpContent),
                                "Help Message", JOptionPane.INFORMATION_MESSAGE);

                    }
                });
        return help;
    }

    /**
     * Name and Version
     */
    public VirtualPiano() {
        super(heading + ", " + version, heading);
    }

    public VirtualPiano(String title, String heading) {
        super(title, heading);
    }

    public static void main(String[] args) {
        new VirtualPiano(heading + ", " + version, heading);

    }

    @Override
    public String getName() {
        return "Virtual Piano";
    }

}


