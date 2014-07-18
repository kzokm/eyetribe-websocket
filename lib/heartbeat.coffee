class Heartbeat
  constructor: (@connection)->
    connection.on 'heartbeat', (data)->
      console.log data

  @intervalMillis = undefined

  start: ->
    connection = @connection

    if Heartbeat.intervalMillis?
      @intervalId = setInterval ->
        connection.send '{"category":"heartbeat"}'
      , Heartbeat.intervalMillis
    else
      self = @
      trackerResponseHander = (data)->
        if data.values?.heartbeatinterval
          Heartbeat.intervalMillis = data.values.heartbeatinterval
          connection.removeListener 'tracker', trackerResponseHander
          self.start()

      connection.on 'tracker', trackerResponseHander
        .send '{"category":"tracker","request":"get","values":["heartbeatinterval"]}'
    @

  stop: ->
    clearInterval @intervalId
    delete @intervalId

module.exports = Heartbeat
