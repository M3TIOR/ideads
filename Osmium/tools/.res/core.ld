/* M3TIOR 2015 */

ENTRY(start)
SECTIONS
{
  .text 0x100000 :	/* We need to make sure we don't step into rom territory, so we load at this mark  */
			/* more specifically, the one meg boundary, which is were rom stops and ram begins.*/
  {
    code = .; _code = .; __code = .;
    *(.text)
    . = ALIGN(4096);
  }					/* Basically what the rest of this does is shove all our sources into*/
					/* one unified binary... */
  .data :
  {
     data = .; _data = .; __data = .;
     *(.data)
     *(.rodata)
     . = ALIGN(4096);
  }

  .bss :
  {
    bss = .; _bss = .; __bss = .;
    *(.bss)
    . = ALIGN(4096);
  }

  end = .; _end = .; __end = .;
}
