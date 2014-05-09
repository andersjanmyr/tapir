'use strict';

require('coffee-script/register');
var httpServer = require('./lib/http-server');

var port = process.env.PORT || 3001;
httpServer.listen(port, function() {
  console.log('Listening on port %d', port);
});


