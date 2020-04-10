# 3DS Homebrew Hello World Example in D

![Screenshot](https://i.imgur.com/aEsHC4w.png)

## Compiling with LDC

LDC has made this process very simple! 

First, go [install devkitPro](https://devkitpro.org/wiki/Getting_Started) like normal. Make sure to install 3DS support!

Then, clone this repo.

```sh
git clone https://github.com/TheGag96/3ds-hello-dlang
```

Go download/install the latest version of [LDC](https://github.com/ldc-developers/ldc).

From the `makescripts` folder in this repo, open up `base_rules`. On the line where it says:

```Makefile
export LDC := ldc2
```

Edit this to be command/path to your LDC executable. (I may remove this hacky line in the future and just force you to put ldc2 in your path.)

Copy the `base_rules` and `3ds_rules` files into `/opt/devkitpro/devkitARM`:

```sh
sudo cp -r /path/to/3ds-hello-dlang/makescripts/* /opt/devkitpro/devkitARM
```

Then, finally...

```sh
cd /path/to/3ds-hello-dlang
make
```

## Compiling with GDC (not recommended)

This is how I first got this working, though I don't recommend it due to how difficult it is and how outdated GDC is. 

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

## Extra libraries

If you want to use my bindings for [citro3d](https://github.com/fincs/citro3d) and [citro2d](https://github.com/devkitPro/citro2d), follow the setup instructions to install those libraries.

## What's working so far

* Using a betterC-like subset of D
* (Mostly complete) bindings for libctru
* (Mostly complete) bindings for citro3d
* (Mostly complete) bindings for citro2d
* Some support for core.stdc (needs to be modified to support newlib's libc implementation)

## Known issues

* Bindings referencing things like sockets or other stuff in the C standard library are incomplete
* Certain D standard library files have to be tweaked to compile properly, and I'm not sure if it can be made better or if that's just how it has to be in this environment.
* The bindings I've written so far have enums renamed to fit the D naming convention, but nothing else really is. Still not sure how I plan on cleaning things like that up.
* My hacky Makefile edits currently copy the path of every D source file into the compile command, which makes it HUGE... Need to figure out how to use `-I` properly. I tried, but I couldn't override the standard library files with my hacked-up versions that way.

## Thanks to...

* Wild for his minimal object.d from [PowerNex](https://github.com/PowerNex/PowerNex)
* [DevkitPro](https://devkitpro.org/)
* The devs of [libctru](https://github.com/smealum/ctrulib)
* The devs of [citro3d](https://github.com/fincs/citro3d)
* [dstep](https://github.com/jacob-carlborg/dstep) for C header file conversion
