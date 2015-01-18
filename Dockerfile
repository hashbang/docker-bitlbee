FROM debian:wheezy



RUN echo "deb http://http.debian.net/debian wheezy-backports main" >> /etc/apt/sources.list && \
apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y -t wheezy-backports libotr5-dev && \
    apt-get install -y \
        build-essential \
        libgnutls-dev \
        libglib2.0-dev \
        xsltproc \
        xmlto \
        asciidoc \
        links \
        stunnel4 \
        sudo \
        git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd bitlbee

RUN git clone https://github.com/dequis/bitlbee.git && \
    cd bitlbee && \
    git fetch && \
    git checkout feat/hip-cat && \
    ./configure \
        --prefix=/usr \
        --etcdir=/etc/bitlbee \
        --sbindir=/usr/bin \
        --pidfile=/var/run/bitlbee/bitlbee.pid \
        --ipcsocket=/var/run/bitlbee/bitlbee.sock \
        --systemdsystemunitdir=/usr/lib/systemd/system \
        --ssl=gnutls \
        --strip=0 \
        --otr=plugin \
        --skype=plugin && \
        make && \
        make install && \
        make install-etc && \
        mkdir /var/lib/bitlbee && \
        mkdir /var/run/bitlbee && \
        chown -R bitlbee /var/lib/bitlbee && \
        chown -R bitlbee /var/run/bitlbee

ADD bitlbee.conf /etc/bitlbee/bitlbee.conf
ADD stunnel.conf /etc/stunnel/stunnel.conf
ADD run.sh /tmp/run.sh

VOLUME /var/lib/bitlbee

USER bitlbee

EXPOSE 6667

# Default command to run on boot

CMD ["bash","/tmp/run.sh"]
