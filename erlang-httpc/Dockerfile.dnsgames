# Erlang 21.3.6 with inets httpc
FROM erlang:21.3.6

ADD .gen/httpserver scripts/dnsgames_init /
ADD erlang-httpc/main.erl /

ENTRYPOINT ["/dnsgames_init"]
CMD ["escript", "/main.erl"]
