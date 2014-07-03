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
