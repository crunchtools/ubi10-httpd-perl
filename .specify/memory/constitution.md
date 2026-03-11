# ubi10-httpd-perl Constitution

> **Version:** 2.0.0
> **Ratified:** 2026-03-10
> **Status:** Active
> **Inherits:** [crunchtools/constitution](https://github.com/crunchtools/constitution) v1.0.0
> **Profile:** Container Image

UBI 10 Perl runtime layer. Inherits Apache httpd from ubi10-httpd and troubleshooting tools from ubi10-core. Does NOT include any database server — use ubi10-httpd-perl-mariadb for database workloads (e.g. Request Tracker).

---

## License

AGPL-3.0-or-later

## Versioning

Follow Semantic Versioning 2.0.0. MAJOR/MINOR/PATCH.

## Base Image

`quay.io/crunchtools/ubi10-httpd:latest` — inherits httpd (enabled), troubleshooting tools (iputils, bind-utils, net-tools, less), cron, procps-ng, diffutils, and systemd hardening.

## Registry

Published to `quay.io/crunchtools/ubi10-httpd-perl`.

## RHSM Registration

Not required. mod_fcgid and perl are available in UBI repos.

## Containerfile Conventions

- Uses `Containerfile` (not Dockerfile)
- Required LABELs: `maintainer`, `description`
- `dnf install -y` followed by `dnf clean all`
- No RHSM registration needed
- Inherits from parent chain: httpd (enabled), systemd-remount-fs/systemd-update-done/systemd-udev-trigger (masked)
- Inherits `STOPSIGNAL SIGRTMIN+3` and `ENTRYPOINT ["/sbin/init"]` from ubi10-core

## Packages Installed

mod_fcgid, perl

Inherited from ubi10-httpd: httpd
Inherited from ubi10-core: iputils, bind-utils, net-tools, less, cronie, procps-ng, diffutils

## Testing

- **Build test**: CI builds the image on every push to main
- **Smoke tests**: httpd active, mod_fcgid loaded, Perl present, negative assertion (mariadb-server NOT installed), package integrity, inherited package verification
- **Security scan**: Recommended (not yet implemented)

## Quality Gates

1. Build — CI builds the Containerfile successfully
2. Test — smoke tests pass (httpd up, mod_fcgid loaded, Perl present, no MariaDB, packages verified)
3. Push — image published only after tests pass
4. Weekly rebuild — cron job picks up base image updates every Monday 4:30 AM UTC

## Downstream Images

ubi10-httpd-perl-mariadb (direct child). Changes cascade via repository_dispatch.
