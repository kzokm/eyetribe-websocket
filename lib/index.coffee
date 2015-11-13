class EyeTribe
  @version = require('./version')
  @Tracker = require('./tracker')
  @Protocol = require('./protocol')
  @GazeData = require('./gazedata')
  @GazeUtils = require('./gazeutils')
  @Point2D = require('./point2d')
  @_ = require('underscore')

  @loop = (config, callback) ->
    if typeof config is 'function'
      [callback, config] = [config, {}]
    @loopTracker = new @Tracker config
      .loop callback

module.exports = EyeTribe
