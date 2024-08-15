FROM registry.stage.redhat.io/ubi9/ubi@sha256:081c96d1b1c7cd1855722d01f1ca53360510443737b1eb33284c6c4c330e537c AS builder

RUN mkdir -p /mnt/rootfs

# To access download.devel.redhat.com when you build locally (Konflux has the CA cert)
# Remove once we switch to CDN ubi9 repos
# RUN curl -fL -o /etc/pki/ca-trust/source/anchors/2022-IT-Root-CA.pem https://certs.corp.redhat.com/certs/2022-IT-Root-CA.pem; update-ca-trust extract

COPY rhel-9.5.0.repo /etc/yum.repos.d/rhel-9.5.0.repo
COPY ubi.repo /etc/yum.repos.d/ubi.repo

# The --nogpgcheck is used because the nightly compose RPMs are not signed
# Remove once we switch to CDN ubi9 repos
RUN \
    dnf install --installroot /mnt/rootfs \
        bash \
        coreutils-single \
        crypto-policies-scripts \
        curl-minimal \
        libdnf-plugin-subscription-manager \
        findutils \
        gdb-gdbserver \
        glibc-minimal-langpack \
        gzip \
        langpacks-en \
        libcurl-minimal \
        redhat-release \
        rootfiles \
        subscription-manager \
        tar \
        vim-minimal \
        yum \
        --releasever 9 --setopt install_weak_deps=false --nodocs --nogpgcheck -y && \
    dnf --installroot /mnt/rootfs -y remove policycoreutils diffutils libselinux-utils && \
    dnf --installroot /mnt/rootfs clean all

RUN rm -rf /mnt/rootfs/var/cache/* /mnt/rootfs/var/log/dnf* /mnt/rootfs/var/log/yum.* /mnt/rootfs/var/lib/dnf/*

# Setup support for subscription-manager secrets
RUN cd /mnt/rootfs/etc && rm -rf ./pki/entitlement-host && ln -sf /run/secrets/etc-pki-entitlement ./pki/entitlement-host && \
    ln -sf /run/secrets/rhsm ./rhsm-host
RUN rm -f /mnt/rootfs/etc/systemd/systemd/multi-user.target.wants/rhsmcertd.service

# Set install langs macro so that new rpms that get installed will
# only install langs that we limit it to.
RUN echo "%_install_langs C.utf8" > /mnt/rootfs/etc/rpm/macros.image-language-conf && \
    echo "LANG=C.utf8" > /mnt/rootfs/etc/locale.conf

# Double check this is needed
RUN rm -f /mnt/rootfs/etc/sysconfig/network-scripts/ifcfg-*

# Remove machine-id on pre generated images
RUN rm -f /mnt/rootfs/etc/machine-id && touch /mnt/rootfs/etc/machine-id && chmod 0444 /mnt/rootfs/etc/machine-id

# Remove the installed redhat.repo file
RUN rm -f /mnt/rootfs/etc/yum.repos.d/redhat.repo

# Import the distro GPG key
RUN rpm --dbpath=/mnt/rootfs/var/lib/rpm/ --import /mnt/rootfs/etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

# Manually mask off the systemd units and service so we don't get a login prompt
RUN cd /mnt/rootfs/etc/systemd/system/ && ln -s /dev/null systemd-logind.service && \
    ln -s /dev/null getty.target && ln -s /dev/null console-getty.service && \
    ln -s /dev/null sys-fs-fuse-connections.mount && ln -s /dev/null systemd-remount-fs.service && \
    ln -s /dev/null dev-hugepages.mount

# Create the /run/lock file
RUN install -d /mnt/rootfs/run/lock -m 0755 -o root -g root

# Create /licenses
RUN install -d /mnt/rootfs/licenses -m 0755 -o root -g root

FROM scratch
LABEL maintainer="Red Hat, Inc." \
      vendor="Red Hat, Inc."
LABEL url="https://www.redhat.com"
LABEL com.redhat.component="ubi9-container" \
      name="ubi9" \
      version="9.5" \
      distribution-scope="public"

#label for EULA
LABEL com.redhat.license_terms="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#UBI"

#labels for container catalog
LABEL summary="Provides the latest release of Red Hat Universal Base Image 9."
LABEL description="The Universal Base Image is designed and engineered to be the base layer for all of your containerized applications, middleware and utilities. This base image is freely redistributable, but Red Hat only supports Red Hat technologies through subscriptions for Red Hat products. This image is maintained by Red Hat and updated regularly."
LABEL io.k8s.description="The Universal Base Image is designed and engineered to be the base layer for all of your containerized applications, middleware and utilities. This base image is freely redistributable, but Red Hat only supports Red Hat technologies through subscriptions for Red Hat products. This image is maintained by Red Hat and updated regularly."
LABEL io.k8s.display-name="Red Hat Universal Base Image 9"
LABEL io.openshift.expose-services=""
LABEL io.openshift.tags="base rhel9"

# TODO: How is this going to be set?
LABEL release="9"

ENV container oci

COPY --from=builder /mnt/rootfs/ /
COPY --from=builder /etc/yum.repos.d/*.repo /etc/yum.repos.d/.

CMD ["/bin/bash"]
