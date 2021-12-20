// M3TIOR 2015

/*
 *
 */

struct {
	unsigned long ax;
	unsigned long bx;
	unsigned long cx;
	unsigned long dx;
	unsigned long bp;
	unsigned long sp;
}cpu;


#ifdef BUILD_HAS_FPU
	struct {

	}fpu;
#endif //HAS FPU

typedef struct {
	unsigned char priority;
	cpu* CPU;
	unsigned long cache_bytes;
	#ifdef BUILD_HAS_FPU
		fpu* FPU;
	#endif //HAS FPU
}process;
