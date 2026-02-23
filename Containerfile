FROM registry.access.redhat.com/ubi10/ubi-init:latest

LABEL maintainer="fatherlinux <scott.mccarty@crunchtools.com>"
LABEL description="UBI 10 base image with Apache httpd, mod_fcgid, Perl, and MariaDB for Request Tracker"

# Register with RHSM to access full RHEL repos
RUN --mount=type=secret,id=activation_key \
    --mount=type=secret,id=org_id \
    if [ -f /run/secrets/activation_key ] && [ -f /run/secrets/org_id ]; then \
        subscription-manager register \
            --activationkey="$(cat /run/secrets/activation_key)" \
            --org="$(cat /run/secrets/org_id)" && \
        subscription-manager attach --auto; \
    fi

RUN dnf install -y \
    httpd \
    mod_fcgid \
    perl \
    mariadb-server \
    mariadb \
    cronie \
    procps-ng \
    && dnf clean all

# Unregister to avoid leaking entitlements in the image
RUN subscription-manager unregister 2>/dev/null || true

# Enable services
RUN systemctl enable httpd mariadb

# Disable unnecessary systemd services for container
RUN systemctl mask systemd-remount-fs.service \
    systemd-update-done.service \
    systemd-udev-trigger.service

STOPSIGNAL SIGRTMIN+3
ENTRYPOINT ["/sbin/init"]
CMD ["/sbin/init"]
