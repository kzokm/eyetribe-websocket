#!env coffee
{full: version} = require './lib/version'

net = require 'net'
http = require 'http'
ws = require 'websocket.io'
fs = require 'fs'

SERVER_HOST = '127.0.0.1'
SERVER_PORT = 6556

TARGET_HOST = '127.0.0.1'
TARGET_PORT = 6555

server = http.createServer()
  .listen SERVER_PORT, SERVER_HOST, ->
    console.log 'LISTEN: ' + SERVER_PORT
  .on 'request', (request, response)->
    if request.url == '/eyetribe.js'
      code = readScript "#{__dirname}/eyetribe-#{version}.js"
    else if request.url == '/eyetribe.min.js'
      code = readScript "#{__dirname}/eyetribe-#{version}.min.js"
    if code
      response.writeHead 200,
        'Content-Type': 'text/javascript; charset: UTF-8'
      response.write code
    else
      response.writeHead 404
    response.end()


readScript = (file) ->
  code = readFile file
  code = code?.replace '$SERVER_HOST', SERVER_HOST
  code = code?.replace '$SERVER_PORT', SERVER_PORT

readFile = (file) ->
  if fs.existsSync file
    code = fs.readFileSync file, 'utf8'
      .toString()

ws.attach server
  .on 'connection', (sock)->
    console.log 'CONNECTED: WS'

    sock
      .on 'message', (data)->
        console.log 'REQUEST: ' + data
        target.write data
      .on 'close', (data)->
        console.log 'DISCONNECTED: WS'
        target.end()
      .on 'error', (error)->
        console.error 'ERROR: WS: ' + error

    target = new net.Socket()
      .on 'data', (data)->
        #console.log 'RESPONSE: ' + data
        try
          sock.write data
        catch e
          console.error 'ERROR: WS: ' + e
      .on 'close', (data)->
        console.log 'CLOSED: TRACKER SERVER'
        sock.end()
      .on 'error', (error)->
        console.error 'ERROR: TRACKER SERVER: ' + error
      .connect TARGET_PORT, TARGET_HOST, ->
        console.log 'OPENED: TRACKER SERVER'
