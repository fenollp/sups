-module(sups_worker).
-behaviour(gen_server).
-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2]).

start_link() ->
    gen_server:start_link(?MODULE, [], []).

init([]) ->
    self() ! req,
    {ok, undefined}.

handle_call(_, _From, State) ->
    {noreply, State}.

handle_cast(_, State) ->
    {noreply, State}.

handle_info(req, State) ->
    catch sups_db_worker:req(req, infinity),
    self() ! req,
    {noreply, State}.

terminate(_, _) ->
    ok.
