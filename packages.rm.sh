#!/bin/sh

apt-get -y purge \
   aisleriot           \
   cheese              \
   empathy             \
   aisleriot           \
   gnome-contacts      \
   gnome-mahjongg      \
   gnome-disk-utility  \
   gnome-terminal      \
   gnome-screenshot    \
   gnome-mines         \
   gnome-sudoku        \
   libreoffice-calc    \
   libreoffice-common  \
   libreoffice-draw    \
   libreoffice-impress \
   libreoffice-math    \
   libreoffice-style-galaxy \
   libreoffice-style-human \
   libreoffice-writer  \
   modemmanager        \
   thunderbird         \

exec apt-get -y autoremove
