FROM abrt/stack-fedora:25

MAINTAINER Jakub Filak <jfilak@redhat.com>

ENV container docker

RUN dnf --releasever=25 -y install libreport-plugin-bugzilla; dnf clean all

LABEL Version=2.0

LABEL RUN="docker run -d --privileged --name NAME \
-v /:/host \
-v /dev/log:/dev/log \
-v /var/run/abrt:/var/run/abrt \
-v /var/run/systemd/journal/socket:/var/run/systemd/journal/socket \
-e HOST=/host' \
-e IMAGE=IMAGE \
-e NAME=NAME \
--pid=host \
--net=host \
IMAGE"

CMD /usr/bin/supervisord -c /etc/supervisord.d/supervisord.ini
