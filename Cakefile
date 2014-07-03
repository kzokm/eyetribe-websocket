coffee = require 'coffee-script'
fs = require 'fs'

files =
  eyetribe: [
    'tracker'
    'event_emitter'
    'heartbeat'
    'eyetribe'
  ]

task 'compile', (options)->
  for output, inputs of files
    raw = ''
    for file in inputs
      file = 'src/' + file + '.coffee'
      raw += fs.readFileSync file, 'utf8'
        .toString()
      raw += '\n'
    code = coffee.compile raw
    output = 'lib/' + output + '.js'
    fs.writeFileSync output, code, 'utf8'
