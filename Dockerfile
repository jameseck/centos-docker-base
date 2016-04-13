FROM centos:centos7

MAINTAINER James Eckersall <james.eckersall@fasthosts.com>
ENV REFRESHED_AT 2016_04_13

RUN useradd -u 950 -U -s /bin/false -M -r -G users docker && \
    yum upgrade -y && yum install -y epel-release inotify-tools && \

    # Supervisord uses this folder, it needs to exists
    mkdir /tmp/sockets && \

    yum install -y python-pip && pip install --upgrade pip && \

    # To get rid of python insecure ssl warning, libffi-devel is missing a file
    # when we remove it, so make sure autoremove returns true, else build fails.
    yum install -y openssl-devel python-devel libffi-devel gcc && \
    pip install requests[security] && \
    yum autoremove -y openssl-devel python-devel libffi-devel gcc || true && \

    pip install supervisor && \
    yum clean all

COPY supervisord.conf /etc/supervisord.conf
COPY init/ /init/
COPY hooks/ /hooks/

ENTRYPOINT ["/bin/sh", "-e", "/init/entrypoint"]
CMD ["run"]
