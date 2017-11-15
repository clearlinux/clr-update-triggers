#!/bin/bash

prefix="$1"

# Try to run all hooks in /usr/libexec/updater
for f in "${prefix}"/usr/libexec/updater/*hook.sh ; do
    if [ -x "$f" ] && [ -f "$f" ]; then
        if [ "$prefix" == "/" ]; then
            "$f" &> /dev/null
        else
            chroot "$prefix" "${f#$prefix}" &> /dev/null
        fi
    fi
done
