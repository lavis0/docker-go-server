FROM debian:stable-slim
LABEL authors="gh/lavis0"

# COPY source destination
COPY docker-go-server /bin/goserver

CMD ["/bin/goserver"]