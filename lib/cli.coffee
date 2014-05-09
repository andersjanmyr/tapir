client = require './client'

main = (args) ->
    port =  3000
    host = 'localhost'
    topic = 'topic'

    console.log client(host, port)

module.exports = main
