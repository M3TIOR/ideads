#build configuration:

first off, I'd like to go ahead and say you didn't see this coming (if you've seen any of my previous work).
because modularity! woot!

##macros:
###index --
 * BUILD_* -- **any macro that specifically defines build related information/context**
 * BUILD_ARCH_* -- **any macro that specifically defines a target architecture**
 * BUILD_BITS_n -- **where (n) is any power of 2 above 16, this is used for configuration of the assembly bootleg**
 * CONFIG_* -- **static configuration info**
###currently supported:
####architecture macros:
 * BUILD_ARCH_x86

---
