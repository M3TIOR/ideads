# This is garbage

I made this when I was in highschool. I was an arrogant piece of shit and
had only six month's experience coding with two languages, I thought I knew
everything. There's no universal way to structure a code repository, every
language has it's own tooling and it's own strucuture. Don't be like me lol.
My friend Austin used this exact structure when making a game engine that
I helped work on, and let me tell you, I did not like crawling through the
redundant subfolders this creates when using `CMake`. My own fault tho.
One of my key motivators for leaving the project.




---------------------------------------------------------------------------

# Darklight Repository Structure

This repository is meant to be a semi-interactive brief on the programming
structure our source will be taking across multiple repositories.

#### Directory Structure:
 * [\<project name>](#root-folder)
   * [exec](#executable-folder)  
     * *platform*
   * [build / dist](#build-folder)
   * [doc](#doc-folder)
   * [include](#include-folder)  
     * *distributor*
	   * *repository/program name*
   * [res / assets](#asset-folder)
   * [lib](#library-folder)
   * [src](#source-folder)
   * [tools](#tools-folder)
     * *distributor*
	   * *tool name*
   * [tests](#tests-folder)

The topology herein has been compiled over my five years as a software developer and is intended to help best optimize the repository workflow while complying with the needs of many different languages. Many of these features will not be needed for your project, but I hope the information will help you at some point.


### Root Folder

The root folder name for the repository should inherit the name of the project, for containerization.

### Executable Folder

The executable folder is implemented when distributing prebuild binaries as a dependency of another project.

### Build Folder
### Documentation Folder
### Include Folder
### Asset Folder
### Source Folder
### Tools Folder
### Tests Folder

 capable of supporting the include
feature, which allows programs to call out to other [API]'s and the like.
Without such a feature, code would be excessively redundant. All programs that
aren't managed in [virtual machines][VM] or scripting environments would need to
do things that would be otherwise unnecessary, and similar can be said for
their [VM] and script counterparts; who rely upon the built-ins that their parent
binaries support. When an [interpreter] or [VM] doesn't support what a program built
within it needs, that program then needs to outsource or build in their own
solution to a problem.

Repositories also need documentation; especially useful information
to users when you have an extensive tool that you want to distribute to a large
audience. Or, in the case of games and such, documentation can simply be a way
for ideas to be fleshed out, lore to be expanded upon, etc. It's most valuable
property though, is that documentation lays the ground-work for how it's
corresponding program behave. **In most cases, a program should be documented
far before programming begins.** This ensures that anyone using the program
can also debug it to some degree, along with being able to accurately use it.
It also makes things easier for the programmers because then they don't have to
think of how the program is to function themselves and they can focus primarily
on the best ways to optimize that programs performance. *The exception being
when the programmer is also the program-architect.* That does not exclude their
code from needing proper documentation however.

Sometimes it's useful to include tools for building a repository with it. It's
a common trend that you will see with large projects to include shell scripts
and other related build tools with a repository as a means of ensuring that
their product can be built and used on any platform.

And of course we all know that no repository is complete without it's source
code.

By using this organization structure you support all that and more. Along with
all our code as well.

To learn what each folder is meant to store and it's use, click on it's
corresponding link in this list. Or if you're viewing this on github, you can
alternatively click the folders readme in the file browser. ***cause, ya' know,
that's exactly what the above links will redirect you to anyway.***

[VM]: https://en.wikipedia.org/wiki/Virtual_machine
[interpreter]: https://en.wikipedia.org/wiki/Interpreter_(computing)
[API]: https://en.wikipedia.org/wiki/Application_programming_interface
