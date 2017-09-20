#!/bin/sh
docker rm -f w.pl
docker pull frew/w.pl
docker run -d --name w.pl \
   -v ~/tmp:/tmp -u "$(id -u)"  \
   --restart=always frew/w.pl
