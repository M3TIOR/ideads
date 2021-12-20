# Include Me Too!

At this point, if you've read any of the other READMEs you'll notice that the
very purpose of these directories is to store files who's function is synonymous
the directory's denoted names.

*With that said, this folder is for storing included code.*

Before this goes too far however, perhaps we should discuss what included code is
explicitly within our system.

## What's an include?

If you're any experienced programmer, you should know that most languages
provide a keyword or syntax meant for including third party code/API's within
your own. This is an include. Any code that is meant to be executed with or
as a part of your code, that may also be distributed to provide others with a
programming interface to your project, is an include.

For example: you want to make an API for the public, this is the folder where
would put anything someone else needs to use what you've created from within
their own project. Where as the [src] folder stores crucial API code, this
folder would be responsible for containing the headers necessary for said code
to be compiled. Thus, when including said headers in another project, you can
then reference and use the code provided within the API.

## Namespaces

The reason you put your included code within a folder under your name and then
the repositories name is simple. Cluttering up the root include folder can
result in code overlaps, and a bunch of other problems. By putting the includes
within a folder under your name succeeded by a folder within it of the
repository name; users can effectively track, support and easily reuse your code
when it gets included by someone else.

[src]: (../bin/README.md)
