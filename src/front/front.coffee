PORT = parseInt(process.env.PORT ? process.argv[2] ? 8000)
BASES = (process.env.BASES ? process.argv[3] ? '').split(',')

hapi = require 'hapi'
server = new hapi.Server()

# test with http://localhost:8000/api/ping
server.connection port: PORT

server.register
    register: require 'wo'
    options:
        bases: BASES
        sneeze: silent: true

server.route
    method: 'GET'
    path: '/'
    handler: (req, reply) -> reply 'Homepage'

server.route
    method: 'GET'
    path: '/api/ping'
    handler: wo: {}

server.route
    method: 'GET'
    path: '/api/members'
    handler: wo: {}

server.route
    path: '/favicon.ico'
    method: 'get'
    config:
        cache: expiresIn: 1000*60*60*24*21
    handler: (request, reply) ->
        reply().code(200).type('image/x-icon')

server.start ->
    console.log 'front', server.info.uri
