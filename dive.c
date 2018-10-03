
#include <stdio.h>

// What can you tell me about this C-function?
//int detect_kick(int16_t gyros_accs[][6], int cur_index, struct detect_kick_state *state)
//{
//}






void do_something(int a, int *b) {
    *b = a + (*b);
}


void main() {
    int a = 3;
    int c = 4;
    int *b = &c;
    do_something(a, b);
    fprintf(stderr, "the result is: %i", c);
}