_ = require 'underscore'
{EventEmitter} = require 'events'

WS_CLOSE_NORMAL = 1000

class Connection extends EventEmitter
  defaultConfig =
    host: '$SERVER_HOST'
    port: parseInt '$SERVER_PORT'
    allowReconnect: true
    reconnectionInterval: 500

  constructor: (config = {})->
    config = _.defaults config, defaultConfig
    @host = config.host
    @port = config.port
    @allowReconnect = config.allowReconnect
    @reconnectionInterval = config.reconnectionInterval

  connect: ->
    unless @socket
      connection = @
      @socket = new WebSocket (if document.location.protocol.startsWith("https") then "wss" else "ws") + "://#{@host}:#{@port}"
      @socket.onopen = ()->
        # nop
      @socket.onclose = (data)->
        handleClose.call connection, data.code, data.reason
      @socket.onmessage = (message)->
        if message.data == 'OK'
          handleOpen.call connection
        else
          handleResponse.call connection, message.data
      @socket.onerror = (error)->
        console.log 'onerror', error
    @

  handleOpen = ->
    @stopReconnection()
    @connected = true
    @emit 'connect'

  handleClose = (code, reason)->
    delete @socket
    if @connected
      @connected = false
      @emit 'disconnect', code, reason
    if code != WS_CLOSE_NORMAL && @allowReconnect
      @reconnect @reconnectionInterval

  handleResponse = (data)->
    for json in data.split "\n"
      if json.length > 0
        response = JSON.parse json
        @emit response.category, response

  disconnect: ->
    @stopReconnection()
    @socket?.close WS_CLOSE_NORMAL

  reconnect: (intervalMillis = @reconnectionInterval)->
    connection = @
    @reconnecting = setTimeout ->
      connection.connect()
    , intervalMillis

  stopReconnection: ->
    @reconnecting = clearTimeout @reconnecting

  send: (request)->
    if @socket
      if request instanceof Object
        request = JSON.stringify request
      @socket.send request


module.exports = Connection
