# Jupyter Callisto
***Python3 magic bindings for C and C++***

So, as of right now this is an idea project, I recently tried working with xeus-cling and was forced to work with anaconda as a result which may have subtracted from what could have been an okay user experience because I absolutely loath container systems. I don't see myself having any use for a *C/C++* kernel in my notebook as of late: having any of my notes dedicated to intricate *C* stuff. The xeus-cling approach, while robust is way to slow and bloated for my liking as well. So I've decided to implement a simple *C/C++* magic system for jupyter.

One of the things I noticed about the *C/C++* languages when considering looking for a kernel in Jupyter is that part of the language is dependent upon the compiler used upon it. This means things like certain preprocessor instructions, and optimization keywords are not always cross compattable between different compilers. This reduces the effectiveness of kernels like xeus-cling considerably because they are limited to execution using a single compiler. My solution in implementing *C/C++* as a magic is the ability for the user to specify the compiler and certain options to the compiler as magic parameters. This would mean users could use any *C* dialect instead of being limited to one based on their kernel.

The proposed magic commands with parameters are as follows:
  * `%cc-session`, `%cpp-session`: Registers a compiler as the default compiler for the current notebook session when run.
  * `%%cc`, `%%cpp`: Registers a cell as *C/C++*. <br/> **Parameters:**
    - `-c`, `--continuous`: When the current cell is executed, it's compiled to an elf binary and linked with the executable state from any *C/C++* nodes with the same argument by applying the linked executable code to a virtual program.
		- `--compiler-args "STRING"`: Passes the compiler the string provided as arguments.
		- `--compiler COMPILER`: Uses the compiler provided to compiler the cell's code, regardless of the session default.
		
***This is by no means a comprehensive or final list, I just wanted to leave this as a note for myself because otherwise I'm pretty confident I'm gonna forget.***

Much love to you all,
M3TIOR <3
