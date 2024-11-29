ARG DISTRIB_RELEASE=24.04
FROM ghcr.io/selkies-project/nvidia-egl-desktop:${DISTRIB_RELEASE}
ARG DISTRIB_RELEASE



USER 0
# Restore file permissions to ubuntu user
RUN if [ -d "/usr/libexec/sudo" ]; then SUDO_LIB="/usr/libexec/sudo"; else SUDO_LIB="/usr/lib/sudo"; fi && \
    chown -R -f -h --no-preserve-root ubuntu:ubuntu /usr/bin/sudo-root /etc/sudo.conf /etc/sudoers /etc/sudoers.d /etc/sudo_logsrvd.conf "${SUDO_LIB}" || echo 'Failed to provide user permissions in some paths relevant to sudo'
#USER 1000

# Install Wine and MangoHUD
RUN apt update
RUN apt install -y software-properties-common wget
RUN dpkg --add-architecture i386
RUN mkdir -pm755 /etc/apt/keyrings
RUN wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
RUN wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/noble/winehq-noble.sources
RUN apt update
RUN apt install -y --no-install-recommends curl tar winehq-staging=9.22~noble-1 mangohud
#RUN apt install -y --no-install-recommends kde-i18n-de


# Replace selkies-gstreamer with fork from skipperro
WORKDIR /skipperro/selkies-gstreamer

# Download and extract the latest release from GitHub
RUN LATEST_RELEASE_URL=$(curl -s https://api.github.com/repos/skipperro/selkies-gstreamer/releases/latest | grep "tarball_url" | cut -d '"' -f 4) \
    && curl -L $LATEST_RELEASE_URL | tar -xz --strip-components=1 -C /skipperro/selkies-gstreamer

# Move extracted files to the appropriate Python packages directory
RUN mkdir -p /usr/local/lib/python3.12/dist-packages/selkies_gstreamer/ \
    && mv -f /skipperro/selkies-gstreamer/src/selkies_gstreamer/* /usr/local/lib/python3.12/dist-packages/selkies_gstreamer/

WORKDIR /

# Clean up
RUN rm -rf /skipperro/selkies-gstreamer

# Copy wine prefix and mangohud settings
#COPY --chown=1000:1000 wineprefix/ /wineprefix/
COPY --chown=1000:1000 mangohud/MangoHud.conf /home/ubuntu/.config/MangoHud/MangoHud.conf
#RUN chown -R ubuntu /wineprefix

# Use BUILDAH_FORMAT=docker in buildah
SHELL ["/usr/bin/fakeroot", "--", "/bin/sh", "-c"]
# Install and configure below this line

# Replace changed files
# Copy scripts and configurations used to start the container with `--chown=1000:1000`
COPY --chown=1000:1000 selkies-entrypoint-nokde.sh /etc/entrypoint.sh
RUN chmod -f 755 /etc/entrypoint.sh
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
