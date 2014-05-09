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

    request = (url) ->
        debug(url)
        client.write "GET #{url} HTTP/1.1\r\n"
        client.write "User-Agent: tapir/1.0.0\r\n"
        client.write "Host: #{host}\r\n"
        client.write "Accept: */*\r\n"
        client.write "\r\n"

    listen = (topic, onEvent) ->
        first = true
        client.connect port, host, ->
            request "/listen/#{topic}"

        client.on 'data', (data) ->
            debug(data)
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
            request "/send/#{topic}/#{message}"

        client.on 'data', (data) ->
            debug(data)
            response = parseResponse(data.toString())
            debug(response)
            client.end()

        client.on 'close', ->
            debug('Connection closed')

    # Main
    return { listen: listen, send: send }


module.exports = connect
