class Heartbeat
  @intervalMillis = undefined

  @start: (tracker)->
    new Heartbeat()
      .start tracker

  start: (tracker)->
    self = @
    connection = tracker.connection

    if Heartbeat.intervalMillis?
      @intervalId ?= setInterval ->
        connection.send '{"category":"heartbeat"}'
      , Heartbeat.intervalMillis

      connection.once 'disconnect', ->
        self.stop()
    else
      tracker.get 'heartbeatinterval', (value)->
        Heartbeat.intervalMillis = value
        self.start tracker
    @

  stop: ->
    @intervalId = clearInterval @intervalId

module.exports = Heartbeat
