// M3TIOR 2015

#include <generated/config.h>
#include <Osmium/display.h>

//&&& END INCLUDES

//&&& END STRUCTS

#define BUILD_VERSION_NUMBER CONFIG_VERSION_NUMBER
#define BUILD_VERSION_NAME CONFIG_VERSION_NAME
#define BUILD_VERSION_MESSAGE CONFIG_VERSION_MESSAGE


//&&& END MACROS

void version_splash_ascii(const char* splash, int width, int height);
unsigned char version_splash(const pixel* splash, int width, int height);

//returns an error code on fail so we can default to a lower resolution
//or ascii art if nessesary.

unsigned char version_splash_custom(void* function);
//when this gets called we pass the height and width to the custom animation.
