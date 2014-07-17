class EventEmitter
  setListener: (type, listener)->
    (this._map ||= {})[type] = listener;

  trigger: (type, value)->
    if this._map
      listener = this._map[type];
      listener.call this, value if listener

module.exports = EventEmitter
