;
var EyeTribe = function() {};

(function() {
  var defaultConfig = {
    host: '127.0.0.1',
    port: 6556,
    version: 1,
    push: true
  }

  var Tracker = function(config) {
    config = _.defaults(config || {}, defaultConfig);
    this.host = config.host;
    this.port = config.port;
    this.values = {
      version: config.version,
      push: config.push
    };
  }

  Tracker.prototype.connect = function() {
    var tracker = this;
    var ws = this.socket
      = new WebSocket('ws://' + this.host + ':' + this.port);
    ws.onmessage = function(message) {
      tracker.dispatchResponse(message.data);
    };
    ws.onopen = function(event) {
      tracker.set(self.values);
      tracker.heartbeat = new Heartbeat(this).start();
    };
    ws.onclose
    return this;
  }

  Tracker.prototype.on = function(type, listener) {
    var dispatcher = this.dispatcher || (this.dispatcher = new EventDispatcher());
    dispatcher.setListener(type, listener);
    return this;
  }

  Tracker.prototype.send = function(request) {
    if (typeof request === 'object') {
      request = JSON.stringify(request);
    }
    this.socket.send(request);
  };

  Tracker.prototype.set = function(values) {
    this.send({
      category: 'tracker',
      request: 'set',
      values: {
        version: 1,
        push: true
      }
    });
  }


  Tracker.prototype.dispatchResponse = function(json) {
    var dispatcher = this.dispatcher;
    if (dispatcher) {
      var response = JSON.parse(json);
      if (response.request == 'get') {
        dispatcher.trigger('value', response.values);
        _.each(response.values, function(value, key) {
          dispatcher.trigger(key, value);
        });
      }
    }
  }


  var EventDispatcher = function() {};

  EventDispatcher.prototype.setListener = function(type, listener) {
    var map = this._map || (this._map = {});
    map[type] = listener;
  }

  EventDispatcher.prototype.trigger = function(type, value) {
    if (this._map) {
      var listener = this._map[type];
      if (listener) listener.call(this, value);
    }
  }


  var Heartbeat = function(socket) {
    this.socket = socket;
  }

  Heartbeat.prototype.start = function() {
    var socket = this.socket;
    this.intervalId = setInterval(function() {
      socket.send('{"category":"heartbeat"}')
    }, 3000);
    return this;
  }


  EyeTribe.Tracker = Tracker;

  EyeTribe.loop = function(config, callback) {
    if (typeof config === 'function') {
      callback = config;
      config = {};
    }

    return new Tracker(config)
      .on('frame', callback)
      .connect();
  }
})()
;
