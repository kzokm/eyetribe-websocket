APINAME = 'eyetribe'

{full: version} = require './lib/version'
BASENAME = "#{APINAME}-#{version}"
isDevelopment = version.indexOf('SNAPSHOT') > 0

gulp = require 'gulp'
util = require 'gulp-util'

gulp.task 'default', ['compress']


browserify = require 'browserify'
exorcist = require 'exorcist'
fs = require 'fs'

gulp.task 'browserify', ->
  browserify
    extensions: ['.coffee']
    debug: isDevelopment
  .add './template/entry.coffee'
  .transform 'coffeeify'
  .bundle (error)->
    if error
      util.log error
      @emit 'end'
  .pipe exorcist "#{BASENAME}.js.map"
  .pipe fs.createWriteStream "#{BASENAME}.js"


uglify = require 'gulp-uglify'
concat = require 'gulp-concat'

gulp.task 'compress', ['browserify'], ->
  gulp.src "#{BASENAME}.js"
  .pipe uglify
    outSourceMap: true
  .pipe concat "#{BASENAME}.min.js"
  .pipe gulp.dest '.'


gulp.task 'watch', ['compress'], ->
  gulp.watch 'lib/*.coffee', ['compress']


gulp.task 'server', ['watch'], ->
  require './server'
