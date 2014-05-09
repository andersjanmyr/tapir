
topicClients = {}

register = (topic, client) ->
    topicClients[topic] = topicClients[topic] or []
    topicClients[topic].push client
    console.log "Registering client: #{topic}"

deregister = (topic, client) ->
    topicClients.delete(topic, client)

clients = (topic) ->
    topicClients[topic] or []

module.exports =
    register: register
    deregister: deregister
    clients: clients


