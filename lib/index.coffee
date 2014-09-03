class EyeTribe
  @Tracker = require('./tracker')
  @version = require('./version')
  @Protocol = require('./protocol')
  @GazeData = require('./gazedata')
  @GazeUtils = require('./gazeutils')
  @Point2D = require('./point2d')
  @_ = require('underscore')

  @loop = (config, callback)->
    if typeof config == 'function'
      [callback, config] = [config, {}]
    @loopTracker = new @Tracker config
      .loop callback

module.exports = EyeTribe
