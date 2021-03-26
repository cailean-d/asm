#include "headers/utils.h"

void mem_copy(char* source, char* dest, int bytes) {
  int i;
  for (i =0; i < bytes ; i++) {
    *(dest + i) = *(source + i);
  }
}
