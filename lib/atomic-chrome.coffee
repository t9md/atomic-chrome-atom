WS_PORT = 64292
STARTUP_DELAY_IN_MS = 1000

Server = null
WSHandler = null

module.exports = AtomicChrome =
  activate: (state) ->
    @startServer()

  startServer: ->
    setTimeout =>
      Server ?= require('ws').Server

      @wss = new Server({port: WS_PORT})

      @wss.on 'connection', (ws) ->
        WSHandler ?= require './ws-handler'
        new WSHandler(ws)

      @wss.on 'error', (err) ->
        console.error(err) unless err.code == 'EADDRINUSE'
    , STARTUP_DELAY_IN_MS

  deactivate: ->
    @wss?.close()
