_ = require 'underscore'
Connection = require './connection'
Heartbeat = require './heartbeat'
Protocol = require './protocol'
Frame = require './gazedata'
{EventEmitter} = require 'events'

class Tracker extends EventEmitter
  defaultConfig =
    version: 1
    push: true

  constructor: (config = {})->
    @config = _.defaults config, defaultConfig
    @heartbeat = new Heartbeat @

  connect: (config = @config)->
    tracker = @
    @connection ?= new Connection config
      .connect()
      .on 'tracker', ->
        handleData.apply tracker, arguments
      .on 'connect', ->
        handleConnect.apply tracker, arguments
      .on 'disconnect', ->
        handleDisconnect.apply tracker, arguments
    @

  handleConnect = ->
    @set @config
    @get Protocol.CONFIG_KEYS, (values)->
      _.extend @config, values
    @heartbeat.start()
    @emit 'connect'

  handleDisconnect = (code, reason)->
    @emit 'disconnect', code, reason
    @removeAllListeners '__values__'

  disconnect: ->
    @connection?.disconnect()
    delete @connection


  handleData = (data)->
    if data.request == 'get' && data.values?
      frame = data.values.frame
      @frame = if frame then new Frame(frame) else undefined
      @emit '__values__', data.values
      for key, value of data.values
        @emit key, value unless key == 'frame'
      @emit 'frame', @frame if @frame

  set: (values)->
    values = _.pick values, Protocol.MUTABLE_CONFIG_KEYS
    @connection.send
      category: 'tracker'
      request: 'set'
      values: values
    @

  get: (keys, callback)->
    if _.isString keys
      do (key = keys)->
        (keys = {})[key] = callback
      callback = undefined

    if _.isArray keys
      if callback?
        valuesCallback = (values)->
          @removeListener '__values__', valuesCallback if callback.call @, values
        @on '__values__', valuesCallback
    else
      for key, callback of keys
        @once key, callback if callback
      keys = _.keys keys

    @connection.send
      category: 'tracker'
      request: 'get'
      values: keys
    @

  loop: (callback)->
    @on 'frame', callback
      .connect()

module.exports = Tracker
