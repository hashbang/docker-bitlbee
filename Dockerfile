FROM debian:jessie

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        libotr5-dev \
        build-essential \
        libgnutls28-dev \
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
        mkdir /var/run/stunnel && \
        chown -R bitlbee /var/lib/bitlbee && \
        chown -R bitlbee /var/run/bitlbee && \
        chown -R bitlbee /var/run/stunnel

ADD bitlbee.conf /etc/bitlbee/bitlbee.conf
ADD stunnel.conf /etc/stunnel/stunnel.conf
ADD run.sh /tmp/run.sh

VOLUME /var/lib/bitlbee

EXPOSE 6697

# Default command to run on boot

CMD ["bash","/tmp/run.sh"]
