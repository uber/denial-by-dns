# Golang 1.12.4 with 'net/http' from stdlib
FROM golang:1.12.4

ADD .gen/httpserver scripts/dnsgames_init /
ADD golang-http/main.go /

RUN go build /main.go && mv main /

ENTRYPOINT ["/dnsgames_init"]
CMD ["/main"]
