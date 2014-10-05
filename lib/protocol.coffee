class Protocol
  @CATEGORIES = [
    'tracker', 'calibration', 'hertbeat'
  ]

  @STATUSCODE_SUCCESS = 200
  @STATUSCODE_NOT_FOUND = 400
  @STATUSCODE_FAILURE = 500
  @STATUSCODE_CALIBRATION_UPDATE = 800
  @STATUSCODE_SCREEN_UPDATE = 801
  @STATUSCODE_TRACKER_UPDATE = 802


  @MUTABLE_CONFIG_KEYS = [
    'version', 'push'
    'screenindex'
    'screenresw', 'screenresh'
    'screenpsyw', 'screenpsyh'
    ]

  @CONFIG_KEYS = @MUTABLE_CONFIG_KEYS.concat [
    'heartbeatinterval'
    'trackerstate'
    'framerate'
    'iscalibrated', 'iscalibrating', 'calibresult'
    ]

  @PROPERTY_KEYS = @CONFIG_KEYS.concat [
    'frame'
    ]

  @TRACKER_CONNECTED  = 0
  @TRACKER_NOT_CONNECTED = 1
  @TRACKER_CONNECTED_BADFW = 2
  @TRACKER_CONNECTED_NOUSB3 = 3
  @TRACKER_CONNECTED_NOSTREAM = 4


  request: (category, request, values)->
    JSON.stringify
      category: category
      request: request
      values: values

  response: (json)->
    category: category
    request: request
    values: values

module.exports = Protocol
