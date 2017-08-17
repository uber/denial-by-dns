-module(main).

-export([main/1]).

main(_) ->
    ok = inets:start(),
    {ok, _} = httpc:request("http://localhost:8080"),

    lists:foreach(
      fun(_) ->
              httpc:request("http://example.org")
      end,
      lists:seq(1, 25)
     ),

    time:sleep(1000),

    httpc:request("http://localhost:8080").
