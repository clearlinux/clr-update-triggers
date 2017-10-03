#!/bin/bash

if [ -x /usr/bin/glib-compile-schemas ]; then
    /usr/bin/glib-compile-schemas --targetdir=/var/cache/glib-2.0/schemas /usr/share/glib-2.0/schemas
fi
