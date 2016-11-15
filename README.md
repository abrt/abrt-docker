Supported tags
==============

* `25`, `latest`

What is Automatic Bug Reporting Tool (ABRT)
-------------------------------------------

ABRT is a set of tools to help users detect and report problems that occurred
within their systems. In the contrary to other problem (crash) reporting tools,
ABRT operates on operating system level and thus does not need to be integrated
into monitored applications. Once you deploy ABRT, every applications running
on your system is being monitored for crashes. There are certain limitations
like applications intercepting their own crashes.

[Automatic Bug Reporting Tool documentation](http://abrt.readthedocs.io/)

What's in the images?
---------------------

The images are build from official [Fedora packages](http://koji.fedoraproject.org/koji/packageinfo?packageID=7861) and
[ABRT development packages](https://copr.fedorainfracloud.org/coprs/g/abrt/devel/).

## Supported problem types

* core dump files (C/C++, Go)
* kernel oopses in journalctl
* kernel vmcores on host's file system

## Supported report destinations

* regular file
* remote hosts
* e-mail
* [Red Hat Bugzilla](https://bugzilla.redhat.com/)
* [CentOS Bug Tracker](https://bugs.centos.org/)
* [Fedora Analysis Framework - FAF](http://abrt.fedoraproject.org/)

## Quickstart

To run start ABRT watching your system for problems run:

```bash
docker run -d --privileged -v /dev/log:/dev/log -v /var/run/systemd/journal/socket:/var/run/systemd/journal/socket -v /:/host -v /var/run/abrt:/var/run/abrt --pid=host --net=host --name NAME IMAGE
```

To list detected problems, analyze the problems and report the problems run:

```bash
docker exec -it NAME abrt
docker exec -it NAME abrt gdb
docker exec -it NAME abrt report
```

## Configuration
Pass `-e ABRT_VERBOSE=NUM` on the run command line to make abrt producing more logs.

Supported Docker versions
-------------------------

This image is officially supported on Docker version 1.12.3.

User feedback
-------------

## Issues

If you have any problems with or questions about this image, please contact us
through a [GitHub issue](https://github.com/abrt/abrt-docker/issues).

## Contributing

You are invited to contribute new features, fixes, or updates, large or small;
we are always thrilled to receive pull requests, and do our best to process
them as fast as we can.

Before you start to code, we recommend discussing your plans through a [GitHub
issue](https://github.com/abrt/abrt-docker/issues), especially for more
ambitious contributions. This gives other contributors a chance to point you in
the right direction, give you feedback on your design, and help you find out if
someone else is working on the same thing.

## Documentation

Documentation for this image is available in the `README.md`
[file](https://github.com/abrt/abrt-docker/blob/master/README.md) in the
`abrt/abrt-docker` [GitHub repo](https://github.com/abrt/abrt-docker).
