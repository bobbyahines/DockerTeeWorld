FROM debian:10
LABEL maintainer="Bobby Hines <bobbyahines@gmail.com>"
LABEL image="bobbyahines/teeworlds:server"

ENV $SERVER_NAME sv_name Teeworlds Example Server
ENV $SERVER_PASS sv_password server secret
ENV $SERVER_MOTD sv_motd Example Message of the Day
ENV $SERVER_PORT sv_port 8303
ENV $SERVER_EXT_PORT sv_external_port 8303
ENV $SERVER_RCON_PASS sv_rcon_password rcon_secret
ENV $SERVER_MAP sv_map dm1

# Update OS and add distribution upgrades
RUN apt update && apt -y dist-upgrade

# Install the dependencies
RUN apt install -y build-essential bam cmake git libfreetype6-dev libsdl2-dev libpnglite-dev libwavpack-dev python3

#Clone the repository
RUN git clone https://github.com/teeworlds/teeworlds --recurse-submodules /srv

# Get into the new dir and run the build protocols
WORKDIR /srv

RUN mkdir -p build
RUN cmake . .
RUN make

RUN echo $SERVER_NAME > /srv/server.cfg
RUN echo $SERVER_PASS >> /srv/server.cfg
RUN echo $SERVER_MOTD >> /srv/server.cfg
RUN echo $SERVER_PORT >> /srv/server.cfg
RUN echo $SERVER_EXT_PORT >> /srv/server.config
RUN echo $SERVER_MAP >> /srv/server.cfg
RUN echo "sv_scorelimit 20" >> /srv/server.cfg
RUN echo "sv_timelimit 10" >> /srv/server.cfg
RUN echo "sv_gametype dm" >> /srv/server.cfg
RUN echo "sv_rcon_password rcon_scubaserver" >> /srv/server.cfg
RUN echo "sv_max_clients 12" >> /srv/server.cfg

EXPOSE 8303

CMD ./teeworlds_srv -f server.cfg
