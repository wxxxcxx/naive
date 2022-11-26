FROM golang:latest as builder

WORKDIR /root

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest && \
    xcaddy build --with github.com/caddyserver/forwardproxy@caddy2=github.com/klzgrad/forwardproxy@naive

FROM debian:latest

ENV DOMAIN=example.com
ENV EMAIL=me@example.com
ENV USERNAME=username
ENV PASSWORD=password
ENV UPSTREAM=example.com:80

EXPOSE 80
EXPOSE 443

WORKDIR /srv

COPY --from=builder /root/caddy ./
COPY ./Caddyfile.template ./start.sh ./

RUN apt update && apt install -y gettext libcap2-bin && \
    setcap cap_net_bind_service=+ep caddy && \
    apt clean autoclean && \
    apt autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

ENTRYPOINT [ "/srv/start.sh" ]
