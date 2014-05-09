net = require 'net'



connect = (host, port) ->
    client = new net.Socket()

    listen = (topic) ->
        client.connect port, host, ->
            client.write "GET /listen/#{topic}\n"
            client.write "\n"

        client.on 'data', (data) ->
            console.log('Received: ' + data);

        client.on 'close', ->
            console.log('Connection closed')

    send = (topic, message) ->
        client.connect port, host, ->
            client.write "GET /listen/#{topic}\n"
            client.write "\n"

        client.on 'data', (data) ->
            console.log('Received: ' + data);

        client.on 'close', ->
            console.log('Connection closed')

    # Main
    return { listen: listen, send: send }


module.exports = connect
