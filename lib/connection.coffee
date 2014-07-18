_ = require 'underscore'
{EventEmitter} = require 'events'

class Connection extends EventEmitter
  defaultConfig =
    host: '$SERVER_HOST'
    port: parseInt '$SERVER_PORT'

  constructor: (config = {})->
    config = _.defaults config, defaultConfig
    @host = config.host
    @port = config.port

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

  disconnect: ->
    if @socket
      @socket.close()
      delete @socket

  send: (request)->
    if @socket
      if request instanceof Object
        request = JSON.stringify request
      @socket.send request

  handleOpen = ->
    unless @connected
      @connected = true
      @emit 'connect'

  handleClose = (code, reason)->
    if @connected
      @connected = false
      @emit 'disconnect', code, reason

  handleResponse = (data)->
    connection = @
    for json in data.split "\n"
      if json.length > 0
        response = JSON.parse json
        @emit response.category, response

module.exports = Connection
