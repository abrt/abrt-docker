#!/bin/bash
# uninstall scriptlet for abrt-docker image

rm -rf /host/var/lib/abrt/
rm -rf /host/usr/local/share/cockpit/abrt/
rm -f /host/etc/dbus-1/system.d/dbus-abrt.conf
rm -f /host/etc/dbus-1/system.d/org.freedesktop.problems.daemon.conf
rm -f /host/usr/local/share/dbus-1/system-services/org.freedesktop.problems.service
