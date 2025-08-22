FROM debian:stable-slim
LABEL authors="gh/lavis0"

# COPY source destination
COPY docker-go-server /bin/goserver

ENV PORT=8991

CMD ["/bin/goserver"]