FROM fedora:28

# Replace https -> http (to enable HTTP cache)
RUN bash -c "for i in /etc/yum.repos.d/*.repo; do sed -i -e 's/https:\/\//http:\/\//g' \$i ; done"

RUN dnf update -y && \
  dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
      https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
    && \
  dnf clean all

# Replace https -> http (to enable HTTP cache): again for rpmfusion
RUN bash -c "for i in /etc/yum.repos.d/*.repo; do sed -i -e 's/https:\/\//http:\/\//g' \$i ; done"

RUN dnf install -y \
    curl git htop man zip unzip vim wget ncdu mc nano time \
    && \
  dnf clean all

RUN \
  wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64 && \
  echo "057ecd4ac1d3c3be31f82fc0848bf77b1326a975b4f8423fe31607205a0fe945  /usr/local/bin/dumb-init" | sha256sum -c && \
  chmod +x /usr/local/bin/dumb-init
ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]

CMD ["/app/deploy/entry.sh"]
