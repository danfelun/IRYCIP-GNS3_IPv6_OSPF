FROM debian:bookworm-slim
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    iproute2 iputils-ping isc-dhcp-client traceroute tcpdump dnsutils curl \
    procps net-tools ca-certificates bash vim-tiny \
 && rm -rf /var/lib/apt/lists/*
CMD ["sleep", "infinity"]
