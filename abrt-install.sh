#!/bin/bash
# install scriptlet for abrt-docker image

mkdir -p /host/var/lib/abrt

mkdir -p /host/usr/local/share/cockpit/
cp -r /usr/local/share/cockpit/abrt/ /host/usr/local/share/cockpit/abrt/

cp /etc/dbus-1/system.d/dbus-abrt.conf /host/etc/dbus-1/system.d/dbus-abrt.conf || exit 1
cp /etc/dbus-1/system.d/org.freedesktop.problems.daemon.conf /host/etc/dbus-1/system.d/org.freedesktop.problems.daemon.conf || exit 1

mkdir -p /host/usr/local/share/dbus-1/system-services
cp /usr/share/dbus-1/system-services/org.freedesktop.problems.service /host/usr/local/share/dbus-1/system-services/org.freedesktop.problems.service || exit 1
