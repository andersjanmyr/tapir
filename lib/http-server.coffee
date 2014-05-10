debug = require('debug')('tapir:http-server')
express = require 'express'

app = express()
serverEvent = require('server-event')()
topics = require('./topics')

broadcast = (topic, message) ->
    topics.clients(topic).forEach (client) ->
        client.sse(message)

register = (topic, client) ->
    topics.register(topic, client)
    client.on 'close', ->
        topics.deregister(topic, client)

app.use(express.static("#{__dirname}/../public"))

app.get '/listen/:topic', serverEvent, (req, res) ->
    debug('listen', req.params)
    topic = req.params.topic
    register(topic, res)
    res.sse(topic, 'Hola senor!')


app.get '/send/:topic/:message', (req, res) ->
    debug('send', req.params)
    topic = req.params.topic
    message = req.params.message
    res.send "Message #{message}, sent to topic #{topic}\n"
    broadcast(topic, message)


module.exports = app

