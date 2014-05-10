debug = require('debug')('tapir:topics')

topicClients = {}

register = (topic, client) ->
    debug "Registering client: #{topic}"
    topicClients[topic] = topicClients[topic] or []
    topicClients[topic].push client

deregister = (topic, client) ->
    debug "Deregistering client: #{topic}"
    clients = topicClients[topic]
    clients.splice(clients.indexOf(client), 1)
    debug clients.length

clients = (topic) ->
    topicClients[topic] or []

module.exports =
    register: register
    deregister: deregister
    clients: clients


