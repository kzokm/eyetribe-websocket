class Tracker
  defaultConfig =
    host: '$SERVER_HOST'
    port: $SERVER_PORT
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
    @socket = new WebSocket 'ws://' + @host + ':' + @port
    @socket.onmessage = (message)->
      tracker.dispatchResponse message.data
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

  on: (type, listener)->
    @dispatcher ||= new EventDispatcher()
    @dispatcher.setListener type, listener
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

  dispatchResponse: (json)->
    dispatcher = @dispatcher
    if dispatcher
      response = JSON.parse json
      if response.request == 'get'
        dispatcher.trigger 'value', response.values
        _.each response.values, (value, key)->
          dispatcher.trigger(key, value)


class EventDispatcher
  setListener: (type, listener)->
    (this._map ||= {})[type] = listener;

  trigger: (type, value)->
    if this._map
      listener = this._map[type];
      listener.call this, value if listener


class Heartbeat
  constructor: (@socket)->

  start: ->
    socket = @socket;
    @intervalId = setInterval ->
      socket.send '{"category":"heartbeat"}'
    , 3000
    @

  stop: ->
    clearInterval @intervalId
    delete @intervalId


class @EyeTribe
  @Tracker = Tracker
  @loop = (config, callback)->
    if typeof config == 'function'
      [callback, config] = [config, {}]
    @loopTracker = new Tracker config
      .on 'frame', callback
      .connect()
