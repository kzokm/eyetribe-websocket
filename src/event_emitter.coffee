class EventEmitter
  setListener: (type, listener)->
    (this._map ||= {})[type] = listener;

  emit: (type, value)->
    if this._map
      listener = this._map[type];
      listener.call this, value if listener
