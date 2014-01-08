netcruncher
===========

Fully automated analysis of Android: Netrunner statistics

This project is home to scripts for number crunching on dbzer0's
Android: Netrunner OCTGN statistics. The vision is to allow fully
automated analysis of said statistics.

Prerequisites
-------------

- bash with standard utilities like grep and sed
- MATLAB or GNU Octave (Octave support is not completely supported at
  this time, but I hope to make it fully compatible eventually)
- Octave extra packages:
  - statistics (available [here][octave-statistics], also check your
    distro's repos)

[octave-statistics]: http://octave.sourceforge.net/statistics/index.html

At this time I have no plans to port the bash script to Windows, but
feel to contribute a port. Using cygwin should work fine otherwise.

Usage
-----

First, run the `preprocess.sh` script. It expects a single positional
parameter which is a statistics file released by dbzer0:

    $ ./preprocess.sh data/OCTGN_stats_anonymized-2013-09-12.csv

This may take a few minutes, depending on your hardware. This will
transform the data file to a format suitable for consumption by MATLAB
or Octave, by replacing faction name strings with integers, deleting
timestamp columns and the like. Output will be placed in the
`preprocessed` directory and includes metadata files describing which
integers correspond to which integers.

If you pass the script the `-N|--dry-run` option, it will output what
it would do, but not change any files. By default, the script aborts
if the output directory. This can be overriden with `-F|--force`. The
script also accepts some other options that control what it will do,
these are undocumented but the script source code should suffice as
description of what they do.


Now we're ready to get crunching! Fire up MATLAB or Octave and run the
`read_stats.m` script. This will read the preprocessed csv file into
the `matches` variable and set up some variables that save you from
memorizing which integers correspond to which column numbers, match
results, identities and the like (Actually, it runs all the scripts in
the `preprocessed/` directory. Take a look at them to see which
variables you get.). Try running some of the other `*.m` scripts as
well, or run `crunch.m` to run them all in sequence, and then start
experimenting on your own!


Contributing
------------

Send me a pull request and I'll probably merge it if it looks good! :D

vim: tw=70:ts=2:sw=2:et
