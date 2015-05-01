#!/bin/dash

docker rm -f w.pl
docker pull frew/w.pl
docker run -d --name w.pl \
   -v ~/tmp:/tmp -u 1000  \
   --restart=always frew/w.pl
