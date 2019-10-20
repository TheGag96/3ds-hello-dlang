# 3DS Homebrew Hello World Example in D

![Screenshot](https://i.imgur.com/aEsHC4w.png)

## Compiling

I'd like to improve on this in the future, as right now it's really hacky... I think things will get better once GCC 10 comes out and GDC gets way updated with `-betterC` and all that.

First, go [install devkitPro](https://devkitpro.org/wiki/Getting_Started) like normal. Make sure to install 3DS support!

Then, clone this repo.

```sh
git clone https://github.com/TheGag96/3ds-hello-dlang
```

Grab the devkitPro [buildscripts](https://github.com/devkitPro/buildscripts) repo:

```sh
git clone https://github.com/devkitPro/buildscripts
cd buildscripts
```

Follow the "Preparing to build" section in README.txt for your system.


Edit the file `dkarm-eabi/scripts/build-gcc.sh` and add `d` to the list of enabled languages:

```sh
../../gcc-$GCC_VER/configure \
  --enable-languages=c,c++,objc,lto,d \
  --with-gnu-as --with-gnu-ld --with-gcc \
  --with-march=armv4t\
```

When you're ready to build, do...

```sh
./build-devkit.sh
```

...as it says under "Building the devkits". Make sure to build devkitARM, and when prompted to enter a path to install it to, choose some folder that is NOT `/opt/devkitpro`.

Let everything build. In my experience, the script halted because GDB failed to build. If so, that's fine.

Copy the contents of the `devkitARM` folder you built to into `/opt/devkitpro/devkitARM`

```sh
sudo cp -r /path/to/my/devkitpro/devkitARM/* /opt/devkitpro/devkitARM
```

From another GDC installation, copy the D standard library files into the devkitARM folder (on my Ubuntu-based installation, it's in `/usr/lib/gcc/x86_64-pc-linux-gnu/9.0.1/include/d`):

```sh
sudo cp -r /some/gdc/path/.../include/d /opt/devkitpro/devkitARM/lib/gcc/arm-none-eabi/9.1.0/include/
```

From the `makescripts` folder in this repo, copy the `base_rules` and `3ds_rules` files into `/opt/devkitpro/devkitARM`:

```sh
sudo cp -r /path/to/3ds-hello-dlang/makescripts/* /opt/devkitpro/devkitARM
```

Then, finally...

```sh
cd /path/to/3ds-hello-dlang
make
```

If you want to use my bindings for [citro3d](https://github.com/fincs/citro3d), follow the setup instructions to install the library.

## What's working so far

* Using a betterC-like subset of D
* (Mostly complete) bindings for libctru
* (Mostly complete) bindings for citro3d

## Known issues

* No support for core.stdc yet (needs to be modified to support newlib's libc implementation)
* Bindings referencing things like sockets or other stuff in the C standard library are incomplete
* Without the -betterC flag, doing stuff with CTFE is less comfy, and certain D standard library files have to be tweaked to compile properly.
* The bindings I've written so far have enums renamed to fit the D naming convention, but nothing else really is. Still not sure how I plan on cleaning things like that up.
* My hacky Makefile edits currently copy the path of every D source file into the compile command, which makes it HUGE... Need to figure out how to use `-I` properly. I tried, but I couldn't override the standard library files with my hacked-up versions that way.

## Thanks to...

* The devs of [libctru](https://github.com/smealum/ctrulib)
* The devs of [citro3d](https://github.com/fincs/citro3d)
* [dstep](https://github.com/jacob-carlborg/dstep) for C header file conversion
