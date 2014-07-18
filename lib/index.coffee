class EyeTribe
  @Tracker = require('./tracker')
  @version = require('./version')

  @loop = (config, callback)->
    if typeof config == 'function'
      [callback, config] = [config, {}]
    @loopTracker = new @Tracker config
      .loop callback

module.exports = EyeTribe
