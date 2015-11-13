Point2D = require './point2d'

class Frame
  @STATE_TRACKING_GAZE = 1
  @STATE_TRACKING_EYES = 1 << 1
  @STATE_TRACKING_PRESENCE = 1 << 2
  @STATE_TRACKING_FAIL = 1 << 3
  @STATE_TRACKING_LOST = 1 << 4

  constructor: (@data) ->
    @timestampString = data.timestamp
    @timestamp = data.time
    @state = data.state

    @raw = @rawCoordinates = new Point2D(data.raw)
    @average = @smoothedCoordinates = new Point2D(data.avg)

    @leftEye = new Eye(Eye.LEFT, data.lefteye)
    @rightEye = new Eye(Eye.RIGHT, data.righteye)
    @eyes = [ @leftEye, @rightEye ]

    @isFixated = data.fix

  dump: ->
    'Gaze Data:<br>' +
    'Frame [ state:' + @state +
    ' | timestamp:' + @timestamp +
    ' | fixated:' + @isFixated +
    ' | raw:' + @raw.toString() +
    ' | average:' + @average.toString() +
    ' ]' +
    '<br><br>Eyes:' +
    '<br>' + @leftEye.dump() +
    '<br>' + @rightEye.dump() +
    '<br><br>Raw JSON: ' + (JSON.stringify @data) +
    '<br>'


class Eye
  @LEFT = 0
  @RIGHT = 1

  constructor: (@type, @data) ->
    @raw = @rawCoordinates = new Point2D(data.raw)
    @average = @smoothedCoordinates = new Point2D(data.avg)
    @pupilCenter = @pupilCenterCoordinates = new Point2D(data.pcenter)
    @pupilSize = data.psize

  dump: ->
    type = switch @type
      when Eye.LEFT then 'left'
      when Eye.RIGHT then 'right'

    "Eye(#{type}) [ " +
    'raw:' + @raw.toString() +
    ' | average:' + @average.toString() +
    ' | pupilSize:' + @pupilSize +
    ' | pupilCenter:' + @pupilCenter.toString() +
    ' ]'


class GazeData extends Frame
  @Eye = Eye

module.exports = GazeData
