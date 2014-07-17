_ = require 'underscore'
Point2D = require './point2d'

class Frame
  constructor: (data)->
    @data = data

    @timestampString = data.timestamp
    @timestamp = data.time
    @state = data.state

    @raw = @rawCoordinates = new Point2D(data.raw)
    @avg = @smoothedCoordinates = new Point2D(data.avg)

    @leftEye = new Eye(Eye.LEFT, data.lefteye)
    @rightEye = new Eye(Eye.RIGHT, data.righteye)
    @eyes = [ @leftEye, @rightEye ]

    @isFixated = data.fix


class Eye
  @LEFT = 0
  @RIGHT = 1

  constructor: (type, data)->
    @type = type
    @data = data

    @raw = @rawCoordinates = new Point2D(data.raw)
    @avg = @smoothedCoordinates = new Point2D(data.avg)
    @pupilCenter = @pupilCenterCoordinates = new Point2D(data.pcenter)
    @pupilSize = data.psize


class GazeData extends Frame
  @Eye = Eye

module.exports = GazeData
