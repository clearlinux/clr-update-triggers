#!/bin/bash

# Try to run files in /usr/libexec/updater
find /usr/libexec/updater -type f -executable -exec {} \;
