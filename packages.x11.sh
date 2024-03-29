#!/bin/sh

sudo snap install keepassxc

exec apt-get --no-install-recommends \
	install -y \
	awesome \
	rofi \
	feh \
	firefox \
	fonts-lohit-knda \
	gnome-system-monitor \
	gnome-power-manager \
	gtk2-engines \
	i3lock \
	libio-all-perl \
	lua-json \
	pavucontrol \
	pcmanfm \
	flameshot \
	suckless-tools \
	terminator \
	ttf-ancient-fonts \
	vim-gtk \
	vlc \
	xautolock \
	xbacklight \
	xcalib \
	xclip \
	xdotool \
	xfonts-terminus \
	xfonts-terminus-oblique \
	xsel \
	xinput
