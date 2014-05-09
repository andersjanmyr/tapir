express = require 'express'

app = express()
serverEvent = require('server-event')()
topics = require('./topics')

broadcast = (topic, message) ->
    console.log(topics.clients(topic))
    topics.clients(topic).forEach (client) ->
        client.sse(message)

app.get '/listen/:topic', serverEvent, (req, res) ->
    topic = req.params.topic
    console.log('listen', topic)

    topics.register(topic, res)
    res.sse('test', "event with name test")
    res.sse('default event name message')

app.use(express.static(__dirname + '/public'));

app.get '/send/:topic/:message', (req, res) ->
    console.log('send', req.params)
    topic = req.params.topic
    message = req.params.message
    console.log('send', topic, message)
    res.send "Message #{message}, sent to topic #{topic}\n"
    broadcast(topic, message)


module.exports = app

