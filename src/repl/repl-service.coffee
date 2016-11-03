REPL_PORT = parseInt(process.env.REPL_PORT ? process.argv[2] ? 10001)
BASES = (process.env.BASES ? process.argv[3] ? '').split(',')

repl = require 'seneca-repl'

seneca = require('seneca')
    tag: 'repl'
    # internal: {logger: require('seneca-demo-logger')}
    debug: short_logs:true
.use 'mesh',
    tag: null               # ensures membership of all tagged meshes
    bases: BASES
    make_entry: (entry) ->
        if 'wo' is entry.tag$
            route: JSON.stringify entry.route
            host: entry.host,
            port: entry.port,
            identifier: entry.identifier$
.use repl
.ready ->
    seneca.repl
        port: REPL_PORT
        alias:
            m: 'role:mesh,get:members'
