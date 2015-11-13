GazeData = require './gazedata'
Eye = GazeData.Eye
Point2D = require './point2d'

class GazeUtils
  # Find average pupil center of two eyes.
  @getEyesCenterNormalized: (leftEye, rightEye) ->
    if leftEye instanceof GazeData
      {leftEye, rightEye} = leftEye

    if leftEye? and rightEye?
      leftEye.pupilCenter.add rightEye.pupilCenter
        .divide 2
    else if leftEye?
      leftEye.pupilCenter
    else if rightEye?
      rightEye.pupilCenter

  # Find average pupil center of two eyes.
  @getEyesCenterPixels: (leftEye, rightEye, screenWidth, screenHeight) ->
    if leftEye instanceof GazeData
      [leftEye, screenWidth, screenHeight] = arguments
    center = @getEyesCenterNormalized leftEye, rightEye

    @getRelativeToScreenSpace center, screenWidth, screenHeight

  minimamEyesDistance = 0.1
  maxinumEyesDistance = 0.3

  # Calculates distance between pupil centers based on previously
  # recorded min and max values.
  @getEyesDistanceNormalized: (leftEye, rightEye) ->
    if leftEye instanceof GazeData
      {leftEye, rightEye} = leftEye

    dist = Math.abs @getDistancePoint2D leftEye.pupilCenter, rightEye.pupilCenter

    if dist < minimamEyesDistance
      minimamEyesDistance = dist
    if dist > maxinumEyesDistance
      maxinumEyesDistance = dist

    dist / (maxinumEyesDistance - minimamEyesDistance)

  # Calculates distance between two points.
  @getDistancePoint2D: (p1, p2) ->
    Math.sqrt Math.pow(p1.x - p2.x, 2) + Math.pow(p1.y - p2.y, 2)

  # Converts a relative point to screen point in pixels.
  @getRelativeToScreenSpace: (point, screenWidth, screenHeight) ->
    if point?
      new Point2D Math.round(point.x * screenWidth), Math.round(point.y * screenHeight)

  # Normalizes a point on screen in screen dims
  @getNormalizedCoords: (point, screenWidth, screenHeight) ->
    if point?
      new Point2D point.x / screenWidth, point.y / screenHeight

  # Maps eye position of gaze coords in pixels within normalized space [x: -1:1 , y: -1:1]
  @getNormalizedMapping: (point, screenWidth, screenHeight) ->
    point = @getNormalizedCoords point, screenHeight, screenHeight
    if point?
      new Point2D point.x * 2 - 1, point.y * 2 - 1

module.exports = GazeUtils
