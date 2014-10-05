class Heartbeat
  constructor: (@tracker)->
    heartbeat = @
    tracker.on 'heartbeatinterval', (intervalMillis)->
      heartbeat.restart intervalMillis

  start: (@intervalMillis)->
    heartbeat = @
    connection = @tracker.connection

    if intervalMillis?
      @intervalId ?= setInterval ->
        connection.send '{"category":"heartbeat"}'
      , intervalMillis

      connection.once 'disconnect', ->
        heartbeat.stop()
    else
      @tracker.get 'heartbeatinterval'
    @

  restart: (intervalMillis)->
    if @intervalMillis != intervalMillis
      @stop()
    @start intervalMillis

  stop: ->
    @intervalId = clearInterval @intervalId

module.exports = Heartbeat
