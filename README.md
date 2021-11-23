# KIANIDRAW

Make *ANI*mations from *KI*ds *DRAW*ings

This project is an application prototype to make **animated pictures from static pictures**. It was originally designed to work on **kids drawings**, but can in fact serve for any drawing/logo/etc.

For now, it's written in POSIX {shell + AWK + M4}, but works around GIMP and ImageMagick. It also requires [mvalues](https://github.com/lonequantum/mvalues).

It's a set of subcommands, united under a `kianidraw` command, that work on a user project directory. There is even a Bash autocompletion program.

The general workflow is:

1. Create a project, set parameters and import resources.
2. Use GIMP to define various elements.
3. Make a script using a special language to define moves.
4. Execute the script.

You can step backward at any time to change the settings/resources/etc.

General documentation, description of the *Kianidraw Animation Language* and code comments will come later.
