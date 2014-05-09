client = require './client'

process.on 'uncaughtException', (error) ->
    console.log error.stack
    process.exit 1

main = (args) ->
    port =  3000
    host = 'localhost'
    topic = 'topic'

    console.log "Connecting to #{host}:#{port} for topic #{topic}"
    client(host, port).listen(topic)

module.exports = main
