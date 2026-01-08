# Overview
A test screen for text and graphics modes on x86 PCs and compatible cards.
The program is used to test hardware and software character generators available for various text and graphics modes.
The test screen consists of a table of 8x32 or 16x16 "Test" labels; each label has a different character attribute applied (from 0 to 0xFF).
# Usage
Assemble the source code:
```
nasm graf.asm -o image.bin
```
Then write it to a bootable medium:
```
sudo dd if=image.img of=/dev/sdX bs=4M status=progress conv=fsync
```
After booting the tested computer, the test image should appear.
Pressing any key will select the next text or graphics mode.

For graphics modes the program tests the software character generator provided in the card's VBIOS.
If the card displays characters incorrectly or not at all, that means the software character generator is not usable in that mode.

# Test results
## Text modes with hardware generator expected to work correctly on 100% of compatible cards
These are the recommended text modes to use when you expect correct and standard behavior across different hardware models.
- 0x02 (80x25 characters, 16 colors or grayscale)
- 0x03 (80x25 characters, 16 colors)

## Text modes with hardware generator working correctly on most cards
Some newer cards (e.g., GTX1660 SUPER) do not support these modes.
- 0x00 (40x25 characters, 16 colors or grayscale)
- 0x01 (40x25 characters, 16 colors)
- 0x07 (80x25 characters, 3 shades of gray)

## Graphics modes using a software character generator (in many cases the test showed limited usability)
- 0x04 (40x25 characters, 4 colors)
- 0x05 (40x25 characters, 4 colors)
- 0x06 (80x25, monochrome)

Limitations are mainly caused by vertical text-scrolling artifacts, lack of screen clearing, and varying behavior of BIOS services (INT 0x10 functions).

In other modes, mostly graphics modes (excluding modes 0x80 and above and VESA modes), the test revealed almost complete lack of usability.
Main reasons for VBIOS software generator unsuitability:
- Limited reproducibility across card models
- Missing implementation of the mode handler
- Visual differences that prevent defining standard behavior for many devices
- Possible missing glyphs or incorrectly displayed characters
- Extremely inefficient software implementation of the generator (CPU copying characters from VRAM to another VRAM location)
