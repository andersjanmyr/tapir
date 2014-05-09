net = require 'net'

urls = {}

register = (url, socket) ->
  urls[url] = urls[url] or []
  urls[url].push socket
  console.log "Registering socket: #{socket.name}"

deregister = (socket) ->
  console.log "Deregistering socket: #{socket.name}"


broadcast = (url, sender, message) ->
  console.log url, sender.name, message, urls
  sockets = urls[url]
  sockets.forEach (socket) ->
    return if socket is sender
    socket.write(message);
    console.log "Sending #{message} to #{socket.name}"

server = net.createServer (socket) ->
  socket.name = socket.remoteAddress + ":" + socket.remotePort
  socket.write "Socket connected #{socket.name}\n"

  socket.on 'data', (data) ->
    console.log data.toString()
    arr = /([A-Z]+) (.*)/.exec data.toString()
    if !arr or arr.length < 2
      return socket.write "Invalid command #{data}Commands should have form COMMAND URL\n"

    [_, command, url] = arr
    console.log "CMD '#{command}', URL '#{url}'"

    if command is 'REG'
      register url, socket

    else if command is 'PUSH'
      broadcast url, socket, command

  socket.on 'end', ->
      deregister socket

module.exports = server

