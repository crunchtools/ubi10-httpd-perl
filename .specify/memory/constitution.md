# ubi10-httpd-perl Constitution

> **Version:** 2.1.0
> **Ratified:** 2026-03-10
> **Amended:** 2026-10-02
> **Status:** Active
> **Inherits:** [crunchtools/constitution](https://github.com/crunchtools/constitution) v1.22.0
> **Profile:** Container Image

This file holds what is specific to ubi10-httpd-perl. The fleet rules and the Container
Image profile (license, versioning, LABELs, the RHSM secret-mount pattern,
systemd conventions, registry, testing and quality gates) apply at the
inherited version and are checked against this repo's files by
`constitution.yml`. They are not restated here.

## Purpose

UBI 10 Perl runtime layer on ubi10-httpd. Published as
`quay.io/crunchtools/ubi10-httpd-perl`.

## Parent Image

`quay.io/crunchtools/ubi10-httpd:latest`. It inherits httpd (enabled) and
everything ubi10-core provides. mod_fcgid and perl are in the UBI repos; no
RHSM registration.

## Packages and Services

- **Packages:** mod_fcgid, perl.
- **Services:** none added; httpd comes enabled from the parent.

## No Database Server

This layer carries no database server. Database workloads (e.g. Request
Tracker) use the ubi10-httpd-perl-mariadb leaf image. The smoke test asserts
`mariadb-server` is NOT installed, alongside httpd active, mod_fcgid loaded,
Perl present and the inherited packages.

## Downstream Images

Build dispatches `parent-image-updated` to ubi10-httpd-perl-mariadb and rt.

## History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-03-03 | Initial Container Image profile constitution |
| 2.0.0 | 2026-03-10 | Rebased onto ubi10-httpd; MariaDB and RHSM removed |
| 2.0.1 | 2026-09-25 | Gatehouse review, triage and pre-commit gates |
| 2.1.0 | 2026-10-02 | Manifest under constitution v1.18.0: profile restatement removed, image specifics kept |
