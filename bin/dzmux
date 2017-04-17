#!/bin/sh
# Ryan Dowell
# 2011/08
# Relies on 'unbuffer' command (Ubuntu package expect-dev)
# (Trickery to replace unbuffer can be used at your own discretion)
#
# This script is a module-based dzen2 master script. The modules push their
# changes to dzen2 when a change occurs, triggering a redraw. No redraws
# happen unless a module pushes a change. Modules are just programs of any
# kind. To add your own module, write a script that produces output for dzen2
# and name it stat_<NAME> in this directory, then change the 'layout' list.
#
# This script might need a few executable or directoy names changed to
# operate correctly. These are marked with <C>.

# Simple variables. To change more, add more variables or
# go change the options in dzen2 at the bottom of the file.
BG='#2c2c32'  # dzen backgrounad
FG='grey70'   # dzen foreground
WIDTH=750     # width of the dzen bar

# Set to 1 or use -d option to print module outputs to stderr
DBUG=0
if [ "$1" = "-d"  -o  "$1" = "--debug" ]; then
  DBUG=1;
fi;

# The dzen2 layout of the other scripts called by this script.
# 'spacer' is a built-in r(9x9) with the same color as the background.
layout='temperature spacer volume media'

# <C> You'll need to cd if this script is executed outside this directory.
cd ~/.dzen || exit 1
echo "Starting..."


# Make a pipe to multiplex inputs from the module scripts.
if [ -p dzpipe ]; then
  echo "Using existing dzpipe."
elif [ ! -p dzpipe ]; then
  echo "No dzpipe exists. Creating..."
  mkfifo dzpipe || { echo 'Could not make dzpipe'>&2; exit 1; }
fi

KIDS=""

# Removes the dzpipe file, then kills all child processes.
shutdown () {
  echo "Shutting down."
  rm dzpipe && echo "dzpipe removed."
  echo "Killing child processes."
  for c in $KIDS; do
    kill $c;
  done
  echo "Done."
  exit 0
}

# Call shutdown() when the process is told to quit.
trap shutdown INT QUIT

# Start the modules, piping them to dzpipe.
echo "Modules starting."
for mod in $layout; do
if [ "$mod" != "spacer" ]; then
  expect_unbuffer stat_$mod | sed --unbuffered "s/^/ITEM $mod /g" > dzpipe &
  KIDS="$KIDS $!"
fi
done

# Main loop
# A simple associative array (rememberer) keeps track of the last string
# returned by every module script.
# The output of print_status_bar is simply the concatenation of all the
# strings. Output from mawk is piped into dzen2.
# <C> You may need to install mawk to replace awk.
echo "Main loop start"
awk -W interactive -v DBUG="$DBUG" -v BG="$BG" -v layout_string="$layout" '
function print_status_bar()
{
  for (i in layout) {
    printf ("%s", rememberer[layout[i]]);
  }
  printf("\n");
}
BEGIN {
  rememberer["spacer"] = "^fg(" BG ")^p(2)^r(9x9)^p(2)^fg()";
  split(layout_string, layout, " ");
}
/^ITEM/ {
  rememberer[$2]=substr($0,length($1 $2) + 3,length($0));
  if (DBUG == 1) { print $0 > ("/dev/stderr"); }
  print_status_bar();
}
' < dzpipe | dzen2 -ta l -bg ${BG} -fg ${FG} -p -e '' -w ${WIDTH}
