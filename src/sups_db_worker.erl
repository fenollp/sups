-module(sups_db_worker).
-behaviour(gen_server).
-export([start_link/0, req/2]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

req(Req, Timeout) ->
    gen_server:call(?MODULE, {req, Req}, Timeout).

init([]) ->
    put(sups_tags, [db]),
    {ok, connected}.

handle_call({req, _}, _From, disconnected = State) ->
    {reply, {error, disconnected}, State};
handle_call({req, Req}, _From, connected = State) ->
    timer:sleep(500),
    {reply, {ok, Req}, State};
handle_call(disconnect, _From, _) ->
    {reply, ok, disconnected};
handle_call(connect, _From, _) ->
    {reply, ok, connected}.

handle_cast(_, State) ->
    {noreply, State}.

handle_info(_, State) ->
    {noreply, State}.

terminate(_, _) ->
    ok.
