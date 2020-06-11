void print_string(char* s) {
  char* video_memory = (char*) 0xb8000;
  while (*s != '\0') {
    *video_memory = *s;
    s++;
    video_memory+=2;
  }
}

void main() {
  char string[] = "Hello there my Dear Friends!";
  print_string(string);
}