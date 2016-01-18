-module(ticket_dispenser_eqc).

-include_lib("eqc/include/eqc.hrl").
-include_lib("eqc/include/eqc_statem.hrl").

-compile(export_all).

initial_state() ->
  1.

reset_args(_State) -> [].

reset() ->
  http(get, "http://localhost:4000/reset").

reset_next(_State, _Result, []) ->
  1.

reset_post(_State, [], Result) ->
  eq(Result, "reset").


take_args(_State) -> [].

take() ->
  Txt = http(get, "http://localhost:4000/take"),
  list_to_integer(Txt).



take_next(State, _Result, []) ->
  State + 1.

take_post(State, [], Result) ->
  eq(Result, State).


weight(_State, take) ->
  10;
weight(_State, reset) ->
  1.

prop_par_ticket_dispenser() ->
  inets:start(),
  with_parameter(print_counterexample, false,
  ?FORALL(Cmds, parallel_commands(?MODULE),
    begin
      reset(),
      {History, State, Result} = run_parallel_commands(?MODULE, Cmds),
      pretty_commands(?MODULE, Cmds, {History, State, Result},
          aggregate(command_names(Cmds),
            Result == ok))
    end)).

http(get, URL) ->
  {ok, {{"HTTP/1.1", 200, "OK"}, _, Txt}} = httpc:request(get, {URL, []}, [], []),
  % timer:sleep(600),
  Txt.
