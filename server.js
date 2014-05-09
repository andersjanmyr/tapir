'use strict';

require('coffee-script/register');
var httpServer = require('./lib/http-server');

process.on('uncaughtException', function(error) {
    console.log(error.stack);
    process.exitr(1);
});

var port = process.env.PORT || 3000;
httpServer.listen(port, function() {
  console.log('Listening on port %d', port);
});


