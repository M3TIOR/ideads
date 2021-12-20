//M3TIOR



//&&& END-STRUCTS

//&&& END-MACROS

//making short work of the memory io machine instructions through inline asm!
void outb(unsigned short port, unsigned char value);
unsigned char inb(unsigned short port);
unsigned short inw(unsigned short port);
