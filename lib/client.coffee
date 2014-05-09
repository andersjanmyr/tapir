net = require 'net'
debug = require('debug')('tapir')

parseResponse = (data) ->
    trim(data.split('\r\n\r\n')[1])

parseEvent = (data) ->
    trim(data.split('data: ')[1] or '')

trim = (str) ->
    str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');

connect = (host, port) ->
    client = new net.Socket()

    listen = (topic, onEvent) ->
        first = true
        client.connect port, host, ->
            client.write "GET /listen/#{topic}\n"
            client.write "\n"

        client.on 'data', (data) ->
            if first
                response = parseResponse(data.toString())
            else
                response = parseEvent(data.toString())
                if response
                    debug(response)
                    onEvent and onEvent(response)

            debug(response)
            first = false

        client.on 'close', ->
            debug('Connection closed')

    send = (topic, message) ->
        client.connect port, host, ->
            client.write "GET /send/#{topic}/#{message}\n"
            client.write "\n"

        client.on 'data', (data) ->
            response = parseResponse(data.toString())
            debug(response);

        client.on 'close', ->
            debug('Connection closed')

    # Main
    return { listen: listen, send: send }


module.exports = connect
