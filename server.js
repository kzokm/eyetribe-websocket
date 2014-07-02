var net = require('net'),
    ws = require('websocket.io');

var SERVER_HOST = '127.0.0.1';
var SERVER_PORT = 6556;

var TARGET_HOST = '127.0.0.1';
var TARGET_PORT = 6555;

var server = ws.listen(SERVER_PORT, SERVER_HOST, function() {
  console.log('LISTEN: ' + SERVER_PORT);
});

server.on('connection', function(sock) {
  console.log('CONNECTED');

  var target = new net.Socket();

  sock
    .on('message', function(data) {
      console.log('REQUEST: ' + data);
      target.write(data);
    })
    .on('close', function(data) {
      console.log('DISCONNECTED');
      target.end();
    })
    .on('error', function(error) {
      console.error('ERROR: ' + error);
    });

  target
    .on('data', function(data) {
      console.log('RESPONSE: ' + data);
      sock.write(data);
    })
    .on('close', function(data) {
      console.log('CLOSED');
      sock.end();
    })
    .on('error', function(error) {
      console.error('ERROR: ' + error);
    })
    .connect(TARGET_PORT, TARGET_HOST, function() {
      console.log('OPEN');
    });

});
