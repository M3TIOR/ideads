/* M3TIOR@Darklight
 *
 * -
 *
 *
 *
 */

#include <../g_include/filesystem.h>

void main(void){

        // I know this looks bad now, but trust me this style of writing asm statements helps alot when looking for stuff...
	asm volatile (
		//assembly template
                #ifdef BUILD_ARCH_ARM32
                "",

                #endif //arm32

                #ifdef BUILD_ARCH_ARM64

                #endif //arm64

                #ifdef BUILD_ARCH_x86
		
                #endif //x86

                #ifdef BUILD_ARCH_x64

                #endif //x64
		:

		//ouput operands
                #ifdef BUILD_ARCH_ARM32

                #endif //arm32

                #ifdef BUILD_ARCH_ARM64

                #endif //arm64

                #ifdef BUILD_ARCH_x86

                #endif //x86

                #ifdef BUILD_ARCH_x64

                #endif //x64
		:

		//input operands
                #ifdef BUILD_ARCH_ARM32

                #endif //arm32

                #ifdef BUILD_ARCH_ARM64

                #endif //arm64

                #ifdef BUILD_ARCH_x86

                #endif //x86

                #ifdef BUILD_ARCH_x64

                #endif //x64
		:

		//clobbers
                #ifdef BUILD_ARCH_ARM32

                #endif //arm32

                #ifdef BUILD_ARCH_ARM64

                #endif //arm64

                #ifdef BUILD_ARCH_x86

                #endif //x86

                #ifdef BUILD_ARCH_x64

                #endif //x64

	);
}
