_ = require 'underscore'
Connection = require './connection'
Protocol = require './protocol'
Frame = require './gazedata'
{EventEmitter} = require 'events'

class Tracker extends EventEmitter
  defaultConfig =
    version: 1
    push: true

  constructor: (config = {})->
    @config = _.defaults config, defaultConfig

  connect: (config = @config)->
    tracker = @
    @connection ||= new Connection config
      .connect()
      .on 'tracker', (data)->
        handleData.call tracker, data
      .on 'connect', (data)->
        tracker.set tracker.config
        tracker.emit 'connect'
      .on 'disconnect', (code, reason)->
        tracker.emit 'disconnect', code, reason
        delete tracker.connection
    @

  disconnect: ->
    @connection.disconnect()

  handleData = (data)->
    tracker = @
    if data.request == 'get'
      frame = data.values.frame
      @frame = if frame then new Frame(frame) else undefined
      @emit 'values', data.values
      _.each data.values, (value, key)->
        tracker.emit key, value unless key == 'frame'
      @emit 'frame', @frame if @frame


  set: (values)->
    values = _.pick values, Protocol.MUTABLE_CONFIG_KEYS
    @connection.send
      category: 'tracker'
      request: 'set'
      values: values
    @

  get: (keys)->
    keys = [ keys ] if _.isString keys
    @connection.send
      category: 'tracker'
      request: 'get'
      values: keys
    @


  loop: (callback)->
    @on 'frame', callback
      .connect()

module.exports = Tracker
