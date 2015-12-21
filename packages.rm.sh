#!/bin/dash

apt-get -y purge \
   aisleriot           \
   cheese              \
   empathy             \
   gnome-mahjongg      \
   gnome-mines         \
   gnome-sudoku        \
   libreoffice-calc    \
   libreoffice-common  \
   libreoffice-draw    \
   libreoffice-impress \
   libreoffice-math    \
   libreoffice-style-galaxy \
   libreoffice-style-human \
   libreoffice-writer

exec apt-get -y autoremove
