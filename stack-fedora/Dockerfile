FROM fedora:25

MAINTAINER Jakub Filak <jfilak@redhat.com>

ENV container docker

RUN dnf clean all
RUN curl -o /etc/yum.repos.d/abrt-devel-fedora-25.repo https://copr.fedorainfracloud.org/coprs/g/abrt/devel/repo/fedora-25/group_abrt-devel-fedora-25.repo
RUN dnf -y install supervisor sendmail abrt-cli-ng abrt-addon-ccpp abrt-addon-kerneloops abrt-addon-vmcore libreport-plugin-mailx libreport-plugin-reportuploader libreport-plugin-logger abrt-dbus gdb augeas python3-argcomplete; dnf clean all

LABEL Version=2.0

# Let the ABRT tools know where the rootfs is located.
RUN sed 's/\(abrt-action-save-package-data\)/\1 -r \/host/' -i /etc/libreport/events.d/abrt_event.conf
RUN sed 's/\(abrt-action-save-container-data\)/\1 -r \/host/' -i /etc/libreport/events.d/abrt_event.conf
RUN sed 's/\(journalctl \)--system/\1 -D \/host\/var\/log\/journal /' -i /etc/libreport/events.d/ccpp_event.conf
RUN sed 's/\(journalctl.*-b\)/\1 -D \/host\/var\/log\/journal /' -i /etc/libreport/events.d/ccpp_event.conf

# Testing signature of packages will not work until we install rpm signature
# keys of all released Fedoras to the image. Let's turn GPG off for now.
RUN augtool set /files/etc/abrt/abrt-action-save-package-data.conf/OpenGPGCheck no

# To get information about the runtime - e.g. /etc/os-release.
# The process' /etc/os-release will be copied to
# the $PROBLEM_DIR/os_info_in_rootdir file.
RUN augtool set /files/etc/abrt/abrt.conf/ExploreChroots yes


# Enable additional reporting workflows.
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

# This wrapper script will be installed on the host until kernel allows us to
# set kernel.core_pattern to a string longer than 128 Bytes.
# https://bugzilla.redhat.com/1386274
ADD bin/abrt-container-coredump /usr/local/bin/abrt-container-coredump
ADD bin/after-file /usr/local/bin/after-file

RUN chmod +x /usr/local/bin/abrt-container-coredump
RUN chmod +x /usr/local/bin/after-file
RUN mkdir -p /run/dbus

ADD etc/supervisord.ini /etc/supervisord.d/supervisord.ini
ADD etc/abrt.sh /etc/profile.d/abrt.sh

CMD /usr/bin/supervisord -c /etc/supervisord.d/supervisord.ini
