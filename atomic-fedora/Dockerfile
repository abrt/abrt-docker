FROM abrt/stack-fedora:25

MAINTAINER Jakub Filak <jfilak@redhat.com>

ENV container docker

RUN dnf --releasever=25 -y install libreport-plugin-bugzilla libreport-fedora abrt-plugin-bodhi; dnf clean all

LABEL Version=2.0

LABEL RUN="docker run -d --privileged \
-v /:/host \
-v /dev/log:/dev/log \
-v /var/run/abrt:/var/run/abrt \
-v /var/run/systemd/journal/socket:/var/run/systemd/journal/socket \
--pid=host \
--net=host \
--name NAME \
IMAGE"

CMD /usr/bin/supervisord -c /etc/supervisord.d/supervisord.ini
