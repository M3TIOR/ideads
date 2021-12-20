[BITS 16]

;this little thing here is to force the cpu into an infinite loop
;that addresses the same chunk of ram contiguously. thus ensureing
;we never accidentally execute something in ram that shouldn't be there.

jmp $
