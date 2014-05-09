'use strict';

require('coffee-script/register');
var httpServer = require('./lib/http-server');

process.on 'uncaughtException', (error) ->
    console.log error.stack
    process.exit 1

var port = process.env.PORT || 3000;
httpServer.listen(port, function() {
  console.log('Listening on port %d', port);
});


