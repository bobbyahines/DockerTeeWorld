FROM debian:latest AS build-stage

# Update OS and add distribution upgrades
RUN apt update && apt -y dist-upgrade

# Install the dependencies
RUN apt install -y build-essential bam cmake git libfreetype6-dev libsdl2-dev libpnglite-dev libwavpack-dev python3

#Clone the repository
RUN git clone https://github.com/teeworlds/teeworlds --recurse-submodules /teeworlds

# Get into the new dir and run the build protocols
WORKDIR /teeworlds
RUN mkdir -p build
RUN cmake . .
RUN make

FROM debian:latest
LABEL maintainer="Bobby Hines <bobbyahines@gmail.com>"
LABEL image="bobbyahines/teeworld:server"
WORKDIR /srv
COPY --from=build-stage /teeworlds/ /srv
COPY server.cfg /srv

EXPOSE 8303
