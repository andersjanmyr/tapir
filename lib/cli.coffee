debug = require('debug')('tapir')
parseArgs = require 'minimist'
exec = require('child_process').exec
Client = require './client'

process.on 'uncaughtException', (error) ->
    console.log error.stack
    process.exit 1

usage = ->
    console.log """
    Usage: tapir [options] [topic] [message]
        --host: The host, default: tapir-server.herokuapp.com
        --port: The port, default: 80
        --cmd: Command (send or listen), default: send
        --help: Prints this message
        topic: The topic you are interested int, defaults: topic
        message: The message, defaults: ping
    """

main = (argv) ->
    args = parseArgs(argv.slice(2))
    host = args.host or 'tapir-server.herokuapp.com'
    port =  args.port or 80
    cmd = args.cmd or 'send'
    script = args.script
    topic = args._[0] or 'topic'
    message = args._[1] or 'ping'

    debug """
    --host: #{host}
    --port: #{port}
    --cmd: #{cmd}
    --script: #{script}
    --help: #{args.help}
    topic: #{topic}
    message: #{message}
    """

    client = Client(host, port)

    if args.help
        usage()
        process.exit 0

    if script
        callback = (message) ->
            exec script, (error, stdout, stderr) ->
                console.log(stdout)

    else
        callback = (message) ->
            console.log(message)

    if cmd is 'send'
        client.send(topic, message)
    else
        client.listen(topic, callback)

module.exports = main
