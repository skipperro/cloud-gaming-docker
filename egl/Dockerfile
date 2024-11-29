ARG DISTRIB_RELEASE=24.04
FROM ghcr.io/selkies-project/nvidia-glx-desktop:${DISTRIB_RELEASE}
ARG DISTRIB_RELEASE

USER 0
# Restore file permissions to ubuntu user
RUN if [ -d "/usr/libexec/sudo" ]; then SUDO_LIB="/usr/libexec/sudo"; else SUDO_LIB="/usr/lib/sudo"; fi && \
    chown -R -f -h --no-preserve-root ubuntu:ubuntu /usr/bin/sudo-root /etc/sudo.conf /etc/sudoers /etc/sudoers.d /etc/sudo_logsrvd.conf "${SUDO_LIB}" || echo 'Failed to provide user permissions in some paths relevant to sudo'
USER 1000

# Use BUILDAH_FORMAT=docker in buildah
SHELL ["/usr/bin/fakeroot", "--", "/bin/sh", "-c"]
# Install and configure below this line

# Replace changed files
# Copy scripts and configurations used to start the container with `--chown=1000:1000`
#COPY --chown=1000:1000 entrypoint.sh /etc/entrypoint.sh
#RUN chmod -f 755 /etc/entrypoint.sh
#COPY --chown=1000:1000 selkies-gstreamer-entrypoint.sh /etc/selkies-gstreamer-entrypoint.sh
#RUN chmod -f 755 /etc/selkies-gstreamer-entrypoint.sh
#COPY --chown=1000:1000 kasmvnc-entrypoint.sh /etc/kasmvnc-entrypoint.sh
#RUN chmod -f 755 /etc/kasmvnc-entrypoint.sh
#COPY --chown=1000:1000 supervisord.conf /etc/supervisord.conf
#RUN chmod -f 755 /etc/supervisord.conf

SHELL ["/bin/sh", "-c"]

USER 0
# Enable sudo through sudo-root with uid 0
RUN if [ -d "/usr/libexec/sudo" ]; then SUDO_LIB="/usr/libexec/sudo"; else SUDO_LIB="/usr/lib/sudo"; fi && \
    chown -R -f -h --no-preserve-root root:root /usr/bin/sudo-root /etc/sudo.conf /etc/sudoers /etc/sudoers.d /etc/sudo_logsrvd.conf "${SUDO_LIB}" || echo 'Failed to provide root permissions in some paths relevant to sudo' && \
    chmod -f 4755 /usr/bin/sudo-root || echo 'Failed to set chmod setuid for root'

USER 1000
ENV SHELL=/bin/bash
ENV USER=ubuntu
ENV HOME=/home/ubuntu
WORKDIR /home/ubuntu

EXPOSE 8080

ENTRYPOINT ["/usr/bin/supervisord"]
