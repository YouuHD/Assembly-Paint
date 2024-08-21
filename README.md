# Paint in Assembly
Paint developed in assembly language

This project is an implementation of a basic drwaing program similar to Paint, entirely developed in assembly language, it allows users draw basic forms like rectangles, lines or handfree draws, and change colors.

## Features
- Draw lines, rectangles.
- Basic color palette.
- Eraser tool.
- Simple graphical interface.

## Screenshot
![image](https://github.com/user-attachments/assets/dec03f2e-0c93-4e01-a19c-37c3a828a65b)

## Technologies Used
- Language: Assembly.
- Platform: DOS, 8086.
- Tools: DOSBox.

## Installation and Execution
1. Clone this repository:
   ```shellscript
      git@github.com:YouuHD/Assembly-Paint.git
   ```
2. Download DOSBox for emulation stuff
   https://www.dosbox.com/
3. Open DOSBox and compile the code
   ```sh
   nasm -f bin paint.asm -o paint.com
   ```
4. Run the program in DOSBox
   ```
   paint.com
   ```
