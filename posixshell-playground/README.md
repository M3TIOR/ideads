# Hello Shell World!

![[Build Status LINK]][Build Status SVG]

Hello everyone out there, I'd like to introduce you to my super awesome scripts
repository, full of all your wildest shell fantasies and fever dreams!

I'm the type of nerd who likes fast things, and shells. One might just call me the
**turtle hermit** of Bourne Shell~ Na, just kidding... I'm more of a novice at this
than an expert; still learning of course. But I play around in shell allot so I figured
I might as well have a place to put all my toys. You know, instead of putting everything
in gists... Git's gist system is helpful, but not when I want to do gigantic things with
a bunch of other smaller things. Which leads me into how this repository is set up.

First off, it's mean to be monolithic; I want every one of my shell sub-projects to
fit in here perfectly. I absolutely hate redundant code. *Nasty stuff that is!*
So what I've done to fill that need is make everything it's own little project
and tied them all together with the core makefile at the root of this repo.

To build projects simply:
```sh
	make PROJECT PROJECT2 ...
```
Easy right? But wait, there's more. *To build every project*:
```sh
	make all
```

Now all that's grand and whatnot, but say you're wondering what projects you
can currently build/ are available to you in the repo:
```sh
	make list
```
or you're just wondering what to do:
```sh
	make help
```
note, `make help` also calls out to `make list`.

And that's the basics for building anything this repo has to offer. Now, I want to
take a moment to ask you, when's the last time you compiled from source and it broke,
or just left broken junk scattered across your operating system because it wasn't
staged properly before release? Well, luckily I'm paranoid, so you won't have to deal
with that here. I've had that stupid problem happen to many times because projects were
tossed together *willy-nilly*. I also know what it's like when clean doesn't do its damn
job properly. That's why I've enforced a strict, stage before deploy procedure. By
default this repo should only *build* what you ask.
```sh
	make PROJECT mode=build
```
If you wish to *install* the project after it builds:
```sh
	make PROJECT mode=install
```
Keep in mind, that a project can't be installed without first being built.
so if you run `make PROJECT mode=install` before you build the project,
it won't do anything!

We shouldn't be seeing any mishaps here. For a full list of the modes you can
pass to each project, simply use `make help` and that will tell you.

I've also encountered the problem of not being able to *uninstall* a program after
compilation because I deleted the repository... because someone thought it was
a good idea to put the only uninstall command in their makefile. That isn't going
to fly here. Even though it's a little extra space, when you install any project
here, a corresponding uninstall script containing a snapshot of all the files
that were a part of it is also installed. So you can uninstall the program without
having to hunt down everything that came with it manually. there's still an uninstall
mode built in to all my projects here, so if you accidentally install something
you didn't want to, you can just easily uninstall it here, instead of calling out
to the other script.

If you ever need to use them, the scripts should be found in:
```make
	$(sysconfdir)/uninstall.d/package.sh
```
Each uninstall script has one optional argument '-p' which when specified will
also remove all user files for that specific project. ***"purge"***

If you'd like to run the tests for any of these projects on your machine just for
shits and giggles, you can do:
```sh
	make PROJECT mode=test
```
and that will run all the tests on PROJECT to make sure you can run it on your machine.
However, beyond use in build automation, this isn't very useful since, most of these
scripts if not all, are going to be built in good old `/bin/sh` or `/bin/dash` and will
function on each machine in the same way because of their common runtime.


[Build Status SVG]: https://travis-ci.org/M3TIOR/Shell-Scripts.svg?branch=master
[Build Status LINK]: https://travis-ci.org/M3TIOR/Shell-Scripts
