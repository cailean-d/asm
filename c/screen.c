#include "headers/screen.h"
#include "headers/port_utils.h"
#include "headers/utils.h"

void print_char(char character, int col, int row, char attributes) {
  // pointer to mapped video memory
  unsigned char *vidmem = (unsigned char*) VIDEO_ADDRESS;

  // if zero, assume the default style
  if (!attributes) {
    attributes = WHITE_ON_BLACK;
  }

  // get video memory offset
  int offset;
  if (col >= 0 && row >= 0) {
    offset = get_screen_offset(col, row);
  } else {
    offset = get_cursor();
  }

  if (character == '\n') {
    int rows = offset / (2 * MAX_COLS);
    offset = get_screen_offset(79, rows);
  } else {
    vidmem[offset] = character;
    vidmem[offset + 1] = attributes;
  }

  offset += 2;
  offset = handle_scrolling(offset);
  set_cursor(offset);
}

int get_screen_offset(int col, int row) {
  return (row * 80 + col) * 2;
}

int get_cursor() {
  port_byte_write(REG_SCREEN_CTRL, 14);
  int offset = port_byte_read(REG_SCREEN_DATA) << 8;
  port_byte_write(REG_SCREEN_CTRL, 15);
  offset += port_byte_read(REG_SCREEN_DATA);
  return offset * 2;
}

void set_cursor(int offset) {
  offset /= 2;
}

void print_at(char* message, int col, int row) {
  if (col >= 0 && row >= 0) {
    set_cursor(get_screen_offset(col, row));
  }

  int i = 0;
  while (message[i] != 0) {
    print_char(message[i++], col, row, WHITE_ON_BLACK);
  }
}

void print(char* message) {
  print_at(message, -1, -1);
}

void clear_screen() {
  int row = 0;
  int col = 0;

  for (row = 0; row < MAX_ROWS; row++) {
    for(col = 0; col < MAX_COLS; col++) {
      print_char(' ', col, row, WHITE_ON_BLACK);
    }
  }

  set_cursor(get_screen_offset(0, 0));
}

int handle_scrolling(int cursor_offset) {
  
  // if cursor is within the screen, scrolling is unnecessary
  if (cursor_offset < MAX_ROWS * MAX_COLS * 2) {
    return cursor_offset;
  }

  // scroll screen
  int i = 0;
  for (i =1; i < MAX_ROWS; i++) {
    char* from = get_screen_offset(0, i) + VIDEO_ADDRESS;
    char* to = get_screen_offset(0, i-1) + VIDEO_ADDRESS;
    mem_copy(from, to, MAX_COLS * 2);
  }

  // clear last line
  char* last_line = get_screen_offset(0, MAX_ROWS-1) + VIDEO_ADDRESS;
  for (i=0; i < MAX_COLS*2; i++) {
    last_line[i] = 0;
  }

  // move cursor position one row back
  cursor_offset -= 2*MAX_COLS;

  // return updated cursor position
  return cursor_offset;
}