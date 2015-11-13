class Heartbeat
  constructor: (@tracker) ->
    heartbeat = this
    tracker.on 'heartbeatinterval', (intervalMillis) ->
      heartbeat.restart intervalMillis

  start: (@intervalMillis) ->
    heartbeat = this
    connection = @tracker.connection

    if intervalMillis?
      @intervalId ?= setInterval ->
        connection.send '{"category":"heartbeat"}'
      , intervalMillis

      connection.once 'disconnect', ->
        heartbeat.stop()
    else
      @tracker.get 'heartbeatinterval'
    this

  restart: (intervalMillis) ->
    if @intervalMillis isnt intervalMillis
      @stop()
    @start intervalMillis

  stop: ->
    @intervalId = clearInterval @intervalId


module.exports = Heartbeat
