# Repository Tools!

Now, this little folder is actually kinda cool. It's main purpose is to allow
you to package build tools with your repo. These build tools can range from
cross-compilers to really whatever suits your imagination. So long as it only
modifies the contents of your repository and is in script format. Which
unfortunately limits you to interpreted languages.

This folder utilizes the same base structure as the include folder. The
intention of this, is to allow someone to publish build tools that aren't
repository specific.

An example of this, is the Fusedshadow project over on M3TIOR's github.
Fusedshadow is supposed to be a multi-repo build tool that utilizes git for
managing remotes and fetching dependencies. However, the long-term goal is to
make a build tool that can build any project with one command. ***(Probably
unobtainable but we'll see...)***
