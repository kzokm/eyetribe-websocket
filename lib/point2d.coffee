class Point2D
  constructor: (x, y) ->
    if x? and not y?
      if x instanceof Array
        [x, y] = x
      else if x.x?
        {x, y} = x
      else if x.left?
        {left: x, top: y} = x
    @x = x or 0
    @y = y or 0

  add: (p2) ->
    new Point2D(@x + p2.x, @y + p2.y)

  subtract: (p2) ->
    new Point2D(@x - p2.x, @y - p2.y)

  multiply: (k) ->
    new Point2D(@x * k, @y * k)

  divide: (k) ->
    new Point2D(@x / k, @y / k)

  average: ->
    (@x + @y) / 2

  toString: ->
    "#{@x}, #{@y}"


module.exports = Point2D
