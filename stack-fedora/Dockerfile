FROM fedora:24

MAINTAINER Jakub Filak <jfilak@redhat.com>

ENV container docker

RUN dnf clean all && dnf update -y fedora-repos
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-25-$(uname -i) && dnf --releasever=25 -y update
RUN curl -o /etc/yum.repos.d/abrt-devel-fedora-25.repo https://copr.fedorainfracloud.org/coprs/g/abrt/devel/repo/fedora-25/group_abrt-devel-fedora-25.repo
RUN dnf --releasever=25 -y install supervisor git sendmail abrt-cli-ng abrt-addon-ccpp abrt-addon-kerneloops abrt-addon-vmcore libreport-plugin-mailx libreport-plugin-reportuploader libreport-plugin-logger abrt-dbus gdb augeas python3-argcomplete; dnf clean all

LABEL Version=2.0

RUN sed 's/\(abrt-action-save-package-data\)/\1 -r \/host/' -i /etc/libreport/events.d/abrt_event.conf
RUN sed 's/\(abrt-action-save-container-data\)/\1 -r \/host/' -i /etc/libreport/events.d/abrt_event.conf
RUN sed 's/\(journalctl \)--system/\1 -D \/host\/var\/log\/journal /' -i /etc/libreport/events.d/ccpp_event.conf
RUN sed 's/\(journalctl.*-b\)/\1 -D \/host\/var\/log\/journal /' -i /etc/libreport/events.d/ccpp_event.conf

RUN augtool set /files/etc/abrt/abrt-action-save-package-data.conf/OpenGPGCheck no
# To get information about the runtime - e.g. /etc/os-release
RUN augtool set /files/etc/abrt/abrt.conf/ExploreChroots yes

# Until the issue below is fixed, we must enable events using sed.
# https://github.com/abrt/abrt/issues/1194
RUN sed 's/# EVENT/EVENT/' -i /etc/libreport/workflows.d/report_mailx.conf
RUN sed 's/# EVENT/EVENT/' -i /etc/libreport/workflows.d/report_logger.conf
RUN sed 's/# EVENT/EVENT/' -i /etc/libreport/workflows.d/report_uploader.conf

LABEL RUN="docker run -d --privileged \
-v /:/host \
-v /dev/log:/dev/log \
-v /var/run/abrt:/var/run/abrt \
-v /var/run/systemd/journal/socket:/var/run/systemd/journal/socket \
--pid=host \
--net=host \
--name NAME \
IMAGE"

ADD bin/abrt-container-coredump /usr/local/bin/abrt-container-coredump
ADD bin/after-file /usr/local/bin/after-file

RUN chmod +x /usr/local/bin/abrt-container-coredump
RUN chmod +x /usr/local/bin/after-file
RUN mkdir -p /run/dbus

ADD etc/supervisord.ini /etc/supervisord.d/supervisord.ini
ADD etc/abrt.sh /etc/profile.d/abrt.sh

CMD /usr/bin/supervisord -c /etc/supervisord.d/supervisord.ini
