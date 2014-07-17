# -*- mode: coffee -*-
# vi: set ft=coffee :

require 'coffee-script/register'
{full: version} = require './lib/version'


TARGET = "eyetribe-#{version}.js"
TARGET_MIN = "eyetribe-#{version}.min.js"
ENTRY = 'template/entry.coffee'


task 'all', (options)->
  browserify options, [ compress ]

task 'browserify', (options)->
  browserify options

task 'compress', (options)->
  compress options


browserify = (options, followings)->
  run "node node_modules/browserify/bin/cmd.js -t coffeeify --extension=.coffee #{ENTRY} -o #{TARGET}",
    followings

compress = (options, followings)->
  run "node node_modules/uglify-js/bin/uglifyjs #{TARGET} -o #{TARGET_MIN}",
    followings


{exec} = require 'child_process'

run = (command, followings)->
  console.log command
  exec command, (error, stdout, stderr)->
    console.log stdout if stdout
    console.error stderr if stderr
    unless error
      next = followings?.shift()
      next followings if next


task 'clean', (options)->
  fs = require 'fs'
  fs.unlink TARGET, ->
  fs.unlink TARGET_MIN, ->
