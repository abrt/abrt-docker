FROM fedora:24

MAINTAINER Jakub Filak <jfilak@redhat.com>

ENV container docker

RUN curl -o /etc/yum.repos.d/abrt-devel-fedora-25.repo https://copr.fedorainfracloud.org/coprs/g/abrt/devel/repo/fedora-25/group_abrt-devel-fedora-25.repo
RUN dnf update -y fedora-repos; rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-25-$(uname -i); dnf --releasever=25 -y update; dnf --releasever=25 -y install supervisor git sendmail abrt-cli-ng abrt-addon-ccpp abrt-addon-kerneloops abrt-addon-vmcore abrt-dbus gdb augeas; dnf clean all

LABEL Version=2.0

RUN sed 's/\(abrt-action-save-package-data\)/\1 -r \/host/' -i /etc/libreport/events.d/abrt_event.conf
RUN sed 's/\(abrt-action-save-container-data\)/\1 -r \/host/' -i /etc/libreport/events.d/abrt_event.conf
RUN sed 's/\(journalctl \)--system/\1 -D \/host\/var\/log\/journal /' -i /etc/libreport/events.d/ccpp_event.conf
RUN sed 's/\(journalctl.*-b\)/\1 -D \/host\/var\/log\/journal /' -i /etc/libreport/events.d/ccpp_event.conf

RUN augtool set /files/etc/abrt/plugins/CCpp.conf/CreateCoreBacktrace no
RUN augtool set /files/etc/abrt/abrt-action-save-package-data.conf/OpenGPGCheck no

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

ADD abrt-container-coredump /usr/local/bin/abrt-container-coredump
ADD after-file /usr/local/bin/after-file

RUN chmod +x /usr/local/bin/abrt-container-coredump
RUN chmod +x /usr/local/bin/after-file
RUN mkdir -p /run/dbus

ADD supervisord.ini /etc/supervisord.d/supervisord.ini

CMD /usr/bin/supervisord
