# ubi10-httpd-perl Constitution

> **Version:** 1.0.0
> **Ratified:** 2026-03-03
> **Status:** Active
> **Inherits:** [crunchtools/constitution](https://github.com/crunchtools/constitution) v1.0.0
> **Profile:** Container Image

UBI 10 base image with Apache httpd, mod_fcgid, Perl, and MariaDB. Primary use case: hosting Request Tracker (RT).

---

## License

AGPL-3.0-or-later

## Versioning

Follow Semantic Versioning 2.0.0. MAJOR/MINOR/PATCH.

## Base Image

`registry.access.redhat.com/ubi10/ubi-init:latest` — systemd-based for multi-service containers (httpd + MariaDB).

## Registry

Published to `quay.io/crunchtools/ubi10-httpd-perl`.

## RHSM Registration

Uses build-time secret mounts for subscription-manager registration to access RHEL repos for packages not available in UBI.

## Containerfile Conventions

- Uses `Containerfile` (not Dockerfile)
- Required LABELs: `maintainer`, `description`
- `dnf install -y` followed by `dnf clean all`
- `subscription-manager unregister` after package installation
- systemd services enabled: httpd, mariadb
- systemd services masked: systemd-remount-fs, systemd-update-done, systemd-udev-trigger
- `STOPSIGNAL SIGRTMIN+3` for proper systemd shutdown
- `ENTRYPOINT ["/sbin/init"]`

## Packages Installed

httpd, mod_fcgid, perl, mariadb-server, mariadb, cronie, procps-ng

## Testing

- **Build test**: CI builds the image on every push to main
- **Security scan**: Recommended (not yet implemented)

## Quality Gates

1. Build — CI builds the Containerfile successfully
2. Weekly rebuild — cron job picks up base image updates every Monday 6 AM UTC
