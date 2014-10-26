class Heartbeat
  constructor: (@tracker)->
    tracker.on 'heartbeatinterval', (intervalMillis)=>
      @restart intervalMillis

  start: (@intervalMillis)->
    connection = @tracker.connection

    if intervalMillis?
      @intervalId ?= setInterval ->
        connection.send '{"category":"heartbeat"}'
      , intervalMillis

      connection.once 'disconnect', =>
        @stop()
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
