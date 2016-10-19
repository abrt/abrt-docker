#!/bin/bash
# install scriptlet for abrt-docker image

mkdir -p /host/usr/local/share/cockpit
cp -r /usr/local/share/cockpit/abrt /host/usr/local/share/cockpit
