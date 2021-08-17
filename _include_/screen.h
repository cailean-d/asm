#ifndef SCREEN_H
#define SCREEN_H

#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80
#define WHITE_ON_BLACK 0x0f

// screen device I/O ports
#define REG_SCREEN_CTRL 0x3d4
#define REG_SCREEN_DATA 0x3d5

#define FB_HIGH_BYTE_COMMAND 14
#define FB_LOW_BYTE_COMMAND 15

void print_char(char character, int col, int row, char attributes);
int get_screen_offset(int col, int row);
int get_cursor();
void set_cursor(int offset);
void print_at(char* message, int col, int row);
void print(char* message);
void clear_screen();
int handle_scrolling(int cursor_offset);

#endif
