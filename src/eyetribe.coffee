#=require tracker
#=require event_dispatcher
#=require heartbeat

class @EyeTribe
  @Tracker = Tracker
  @loop = (config, callback)->
    if typeof config == 'function'
      [callback, config] = [config, {}]
    @loopTracker = new Tracker config
      .on 'frame', callback
      .connect()
