FROM debian:wheezy

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        build-essential \
        libgnutls-dev \
        libglib2.0-dev \
        libotr2-dev \
        sudo \
        git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone https://github.com/dequis/bitlbee.git && \
    cd bitlbee && \
    git fetch && \
    git checkout feat/hip-cat && \
    ./configure \
        --prefix=/usr \
        --etcdir=/etc/bitlbee \
        --sbindir=/usr/bin \
        --pidfile=/run/bitlbee/bitlbee.pid \
        --ipcsocket=/run/bitlbee/bitlbee.sock \
        --systemdsystemunitdir=/usr/lib/systemd/system \
        --ssl=gnutls \
        --strip=0 \
        --otr=plugin \
        --skype=plugin && \
        make && \
        make install

VOLUME /var/lib/bitlbee

ADD run.sh /tmp/run.sh

RUN useradd bitlbee

USER bitlbee

EXPOSE 6697

# Default command to run on boot
CMD ["/usr/sbin/bitlbee", "-D", "-n"]
