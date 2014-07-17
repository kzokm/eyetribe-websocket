class Point2D
  constructor: (x, y)->
    unless y?
      if x instanceof Array
        [x, y] = x
      else
        {x, y} = x
    @x = x
    @y = y

  add: (p2)->
    new Point2D(@x + p2.x, @y + p2.y)

  subtract: (p2)->
    new Point2D(@x - p2.x, @y - p2.y)

  multiply: (value)->
    new Point2D(@x * value, @y * value)

  divide: (value)->
    new Point2D(@x / value, @y / value)

module.exports = Point2D
