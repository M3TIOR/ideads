/* M3TIOR 2015
 *
 * oh my god not this again....
 *
 * How many times am I GOING TO GO THROUGH THIS WITH YOU, YOU STUPID COMPUTER!!!!
 * I DON'T CARE THAT PUSHING A 32BIT REGISTER IS ILLEGAL FOR YOUR ARCHITECTURE AND IT'LL KILL YOU IF YOU TRY.
 * I AM SO F#(K!NG DONE WITH THIS! WHAT A PAIN IN THE ARSE YOU CAN BE RIGHT!?
 *
 * ...
 *
 * all the rants were had this day...
 *
 * now we're going to see if this compiles... gee great, I can't wait...
 */

#include <generated/config.h>

#ifdef BUILD_BITS_32
        #define var dd
        #define reg(x) e(x)x
#endif BUILD_BITS_32
#ifdef BUILD_BITS_64
        #define var dq
        #define reg(x) r(x)x
#endif

//eh I'mma see if this compiles first

volatile asm (
        //header info
        ".global mboot;\n\t",
        ".extern code;\n\t",
        ".extern bss;\n\t",
        ".extern end;\n\t",

        ".global start;\n\t",
        ".extern main;\n\t",
        "\n\t"

        :
        ""
        :
        ""
        :
        ""
);
