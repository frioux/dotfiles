#!/bin/sh

exec apt-get --no-install-recommends    \
                             install -y \
   acpi                                 \
   atop                                 \
   dstat                                \
   glances                              \
   ioping                               \
   linux-tools-common                   \
   linux-tools-generic                  \
   nicstat                              \
   powertop                             \
   sysstat                              \
   trace-cmd
