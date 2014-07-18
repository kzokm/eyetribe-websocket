_ = require 'underscore'
Heartbeat = require './heartbeat'
Frame = require './gazedata'
{EventEmitter} = require 'events'

class Tracker extends EventEmitter
  defaultConfig =
    host: '$SERVER_HOST'
    port: parseInt '$SERVER_PORT'
    version: 1
    push: true

  constructor: (config = {})->
    config = _.defaults config, defaultConfig
    @host = config.host
    @port = config.port
    @values =
      version: config.version
      push: config.push

  connect: ->
    tracker = @
    @socket = new WebSocket "ws://#{@host}:#{@port}"
    @socket.onmessage = (message)->
      tracker.handleResponse message.data
    @socket.onopen = (event)->
      tracker.onConnect
      tracker.set tracker.values
      tracker.heartbeat = new Heartbeat @
        .start();
    @socket.onclose = (event)->
      tracker.heartbeat.stop()
    @socket.onerror = (error)->
      console.log 'onerror', error
    @

  send: (request)->
    if request instanceof Object
      request = JSON.stringify request
    @socket.send request

  set: (values)->
    @send
      category: 'tracker'
      request: 'set'
      values: values

  handleResponse: (json)->
    tracker = @
    response = JSON.parse json
    if response.category == 'tracker' && response.request == 'get'
      frame = response.values.frame
      @frame = if frame then new Frame(frame) else undefined
      @emit 'values', response.values
      _.each response.values, (value, key)->
        tracker.emit key, value unless key == 'frame'
      @emit 'frame', @frame if @frame

  loop: (callback)->
    @on 'frame', callback
      .connect()

module.exports = Tracker
