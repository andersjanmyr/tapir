net = require 'net'



connect = (host, port) ->
    client = new net.Socket()

    listen = (host, port, topic) ->
        client.connect port, host, ->
            client.write "GET /listen/#{topic}\n"
            client.write "\n"

        client.on 'data', (data) ->
            console.log('Received: ' + data);

        client.on 'close', ->
            console.log('Connection closed')

    send = (host, port, topic, message) ->
        client.connect port, host, ->
            client.write "GET /listen/#{topic}\n"
            client.write "\n"

        client.on 'data', (data) ->
            console.log('Received: ' + data);

        client.on 'close', ->
            console.log('Connection closed')

    # Main
    client.connect port, host, ->
        { listen: listen, send: send }


module.exports = connect
