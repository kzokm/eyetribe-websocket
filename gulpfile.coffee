{full: version} = require './lib/version'
TARGET = "eyetribe-#{version}"
isDevelopment = version.indexOf 'SNAPSHOT' > 0

gulp = require 'gulp'
browserify = require 'browserify'
uglify = require 'gulp-uglify'
source = require 'vinyl-source-stream'
concat = require 'gulp-concat'

gulp.task 'default', ['compress']

gulp.task 'browserify', ->
  browserify
    entries: ['./template/entry.coffee']
    extensions: ['.coffee']
    debug: true
  .transform 'coffeeify'
  .bundle (error)->
    console.error error if error
  .pipe source TARGET + '.js'
  .pipe gulp.dest '.'
  @

gulp.task 'compress', ['browserify'], ->
  gulp.src TARGET + '.js'
  .pipe uglify
    outSourceMap: true
  .pipe concat TARGET + '.min.js'
  .pipe gulp.dest '.'

gulp.task 'watch', ['compress'], ->
  gulp.watch 'lib/*.coffee', ['compress']

gulp.task 'server', ['watch'], ->
  require './server'
