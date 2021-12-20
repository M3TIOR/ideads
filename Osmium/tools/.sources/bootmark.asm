[BITS 16]

;To make sure we can boot from the disk we are compiling the project to.
;These two bytes are shoved in the last two bytes of the mbr.

db 0x55
db 0xaa

;this means we are going to have 510 bytes of space for extra boot info.
;instead of 512... just as a reminder...
