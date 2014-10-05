_ = require 'underscore'
{EventEmitter} = require 'events'

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
      @socket = new WebSocket "ws://#{@host}:#{@port}"
      @socket.onopen = ()->
        handleOpen.call connection
      @socket.onclose = (data)->
        handleClose.call connection, data.code, data.reason
      @socket.onmessage = (message)->
        handleResponse.call connection, message.data
      @socket.onerror = (error)->
        console.log 'onerror', error
    @

  handleOpen = ->
    @stopReconnection()
    unless @connected
      @connected = true
      @emit 'connect'

  handleClose = (code, reason)->
    delete @socket
    if @connected
      @disconnect()
      @emit 'disconnect', code, reason
      @reconnect @reconnectionInterval if @allowReconnect
    else if @reconnecting
      @reconnect @reconnectionInterval
    else
      @emit 'disconnect', code, reason

  handleResponse = (data)->
    for json in data.split "\n"
      if json.length > 0
        response = JSON.parse json
        @emit response.category, response

  disconnect: ->
    @stopReconnection()
    @connected = false
    @socket?.close()

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
