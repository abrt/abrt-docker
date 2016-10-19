FROM fedora:latest

MAINTAINER Jakub Filak <filak.jakub@gmail.com>

ENV container docker

RUN dnf -y update; dnf -y install supervisor git sendmail abrt-tui abrt-cli-ng abrt-addon-ccpp abrt-addon-kerneloops abrt-addon-vmcore abrt-dbus libreport-fedora libreport-plugin-\* gdb augeas; dnf clean all

LABEL Version=2.0

RUN sed 's/\(abrt-action-save-package-data\)/\1 -r \/host/' -i /etc/libreport/events.d/abrt_event.conf
RUN sed 's/\(abrt-action-save-kernel-data\)/\1 -r \/host/' -i /etc/libreport/events.d/koops_event.conf
RUN sed 's/\(abrt-action-save-container-data\)/\1 -r \/host/' -i /etc/libreport/events.d/abrt_event.conf
RUN sed 's/\(journalctl \)--system/\1 -D \/host\/var\/log\/journal /' -i /etc/libreport/events.d/ccpp_event.conf
RUN sed 's/\(journalctl.*-b\)/\1 -D \/host\/var\/log\/journal /' -i /etc/libreport/events.d/ccpp_event.conf

RUN augtool set /files/etc/abrt/plugins/CCpp.conf/CreateCoreBacktrace no

LABEL INSTALL="docker run --privileged --rm -v /:/host IMAGE \
/usr/local/bin/abrt-install.sh"

LABEL UNINSTALL="docker run --privileged --rm -v /:/host IMAGE \
/usr/local/bin/abrt-uninstall.sh"

LABEL RUN="docker run -d --privileged --name NAME \
-v /dev/log:/dev/log \
-v /:/host \
-e HOST=/host' \
-e IMAGE=IMAGE \
-e NAME=NAME \
--pid=host \
--net=host \
IMAGE"

RUN git clone --depth=1 --single-branch -b master https://github.com/abrt/cockpit-abrt.git /usr/local/share/cockpit

ADD abrt-install.sh /usr/local/bin/abrt-install.sh
ADD abrt-uninstall.sh /usr/local/bin/abrt-uninstall.sh
ADD abrt-container-coredump /usr/local/bin/abrt-container-coredump

RUN chmod +x /usr/local/bin/abrt-install.sh
RUN chmod +x /usr/local/bin/abrt-uninstall.sh
RUN chmod +x /usr/local/bin/abrt-container-coredump
RUN mkdir -p /run/dbus

ADD supervisord.ini /etc/supervisord.d/supervisord.ini

CMD /usr/bin/supervisord
