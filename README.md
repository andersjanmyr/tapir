## Tapir

Tapir is a messaging application meant to be used for synchronizing tasks
across machines. It consists of a client and a server.

## Client

The client handles two commands (`--cmd`), `send` and `listen`. If you listen
for a topic you will be notified every time a message is sent to your topic.

### `tapir --cmd listen`

```
# Open a connection to the server that listens for `send`s on the topic
# .../roman-numerals-kata, run git pull when a message arrives
tapir --cmd listen 'https://github.com/andersjanmyr/roman-numerals-kata' \
  --script 'git pull'
```

### `tapir --cmd send`

```
# Send a message (ping) to the topic .../roman-numerals-kata
# tapir --cmd defaults to send so there is no need to write --cmd send
tapir 'https://github.com/andersjanmyr/roman-numerals-kata'
```

### `tapir --help`

```
Usage: tapir [options] [topic] [message]
  --host: The host, default: tapir-server.herokuapp.com
  --port: The port, default: 80
  --cmd: Command (send or listen), default: send
  --help: Prints this message
  topic: The topic you are interested int, defaults: topic
  message: The message, defaults: ping
```

### Accessing a local server

If you want to run a server locally you can access with the options `--host`
and `--port`.

```
# Send a ping to a local server
tapir --host localhost --port 3000 my-local-topic
```


## Server

There is a running server at `http://tapir-server.herokuapp.com`. The client
defaults to this address so if you don't mind your messages being public you
are good to go.

If you want to run a local server,  the server is started with `npm start` and
it starts a server on `process.env.PORT` or 3000 if PORT is not set.


## Implementation
