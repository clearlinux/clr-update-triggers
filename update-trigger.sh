#!/bin/bash

# Try to run all hooks in /usr/libexec/updater
for f in /usr/libexec/updater/*hook.sh ; do
    [ -x "$f" ] && [ -f "$x" ] && "$f"
done
