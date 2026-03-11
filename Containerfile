FROM quay.io/crunchtools/ubi10-httpd:latest

LABEL maintainer="fatherlinux <scott.mccarty@crunchtools.com>"
LABEL description="UBI 10 Perl runtime layer — inherits Apache httpd from ubi10-httpd"

# mod_fcgid and perl available in UBI repos — no RHSM needed
RUN dnf install -y \
      mod_fcgid \
      perl \
    && dnf clean all
