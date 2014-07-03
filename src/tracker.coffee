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
