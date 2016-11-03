PORT = parseInt(process.env.PORT ? process.argv[2] ? 8001)
BASES = (process.env.BASES ? process.argv[3] ? '').split(',')

Hapi   = require 'hapi'
Chairo = require 'chairo'
Seneca = require 'seneca'

server = new Hapi.Server()

server.connection port: PORT


serverSeneca = require('seneca') {
    tag: 'members',
    # internal: {logger: require('seneca-demo-logger')},
    debug: short_logs: true
    transport: type: 'tcp'
}
.use 'seneca-as-promised'

server.register
    register: Chairo
    options:
        seneca: Seneca
            tag: 'api'
            # internal: logger: require('seneca-demo-logger')
            debug: short_logs: true

server.register
    register: require 'wo'
    options:
        bases: BASES
        route: [
            { path: '/api/ping' }
            { path: '/api/members' }
        ]
        sneeze: silent: true

server.route
    method: 'GET'
    path: '/api/ping'
    handler: (req, reply) ->
        server.seneca.act(
            'role:api,cmd:ping',
            (err, out) -> reply err ? out
        )

server.route
    method: 'GET'
    path: '/api/members'
    handler: ( req, reply ) ->
        server.seneca.act(
            'role:api,cmd:members',
            (err,out) -> reply err ? out
        )

SenecaPromisified = require 'seneca-promisified'

seneca = new SenecaPromisified server.seneca
seneca.add 'role:api,cmd:ping', (msg) -> { pong: true, api: true, time: Date.now() }
seneca.use 'mesh', bases: BASES

server.start -> console.log 'api', server.info.host, server.info.port


