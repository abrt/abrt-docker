#!/usr/bin/bash

echo "Starting abrtd."
abrtd || exit 1

echo "Starting abrt-dump-journal-oops."
abrt-dump-journal-oops -a -fxtD &

echo "Starting abrt-dbus."
abrt-dbus -t 2147483647
