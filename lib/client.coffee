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

    writeHeader = (text) ->
        client.write "#{text}\r\n"

    request = (url) ->
        debug(url)
        writeHeader "GET #{url} HTTP/1.1"
        writeHeader "User-Agent: tapir/1.0.0"
        writeHeader "Host: #{host}"
        writeHeader "Accept: */*"
        writeHeader ""

    listen = (topic, onEvent) ->
        first = true
        client.connect port, host, ->
            request "/listen/#{encodeURIComponent(topic)}"

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
            request "/send/#{encodeURIComponent(topic)}/#{encodeURIComponent(message)}"

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
