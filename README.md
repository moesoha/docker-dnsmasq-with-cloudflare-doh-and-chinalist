# dnsmasq-with-cloudflare-doh-and-chinalist
A dockerfile for building a dnsmasq container with DoH and China Domain List.

# Usage

    mkdir docker-chinalist-dns && cd docker-chinalist-dns
    git clone https://github.com/moesoha/docker-dnsmasq-with-cloudflare-doh-and-chinalist.git .
    docker build -t chinalist-dns:latest .
    docker run -p 53:53 chinalist-dns:latest
    
