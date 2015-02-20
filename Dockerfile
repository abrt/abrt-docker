FROM fedora:latest

MAINTAINER Jakub Filak

ENV container docker

RUN yum -y update; yum -y install abrt-tui abrt-addon-ccpp abrt-addon-kerneloops abrt-addon-vmcore abrt-dbus libreport-fedora libreport-plugin-\* gdb ; yum clean all

LABEL Version=1.0

LABEL RUN="docker run -d --privileged --name NAME \
-v /var/tmp/abrt:/var/tmp/abrt \
-v /var/run:/var/run \
-v /:/host \
-e HOST=/host -e IMAGE=IMAGE -e NAME=NAME \
--net=host \
--restart=always \
IMAGE abrtd"

ENTRYPOINT /usr/sbin/abrtd
