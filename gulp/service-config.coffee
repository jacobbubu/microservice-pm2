BASES = process.env.BASES ? '127.0.0.1:39000,127.0.0.1:39001'
OPTS = process.env.OPTS ? '--seneca.options.debug.undead=true --seneca.options.plugin.mesh.sneeze.silent=1'

services = [
    {
        name: 'services-base0'
        script: './lib/base/base.js'
        args: ['base0', 39000, BASES, OPTS]
        watch: ['./lib/base']
    }
    {
        name: 'services-base1'
        script: './lib/base/base.js'
        args: ['base1', 39001, BASES, OPTS]
        watch: ['./lib/base']
    }
    {
        name: 'services-repl'
        script: './lib/repl/repl-service.js'
        args: [10001, BASES, OPTS]
        watch: ['./lib/repl']
    }
    {
        name: 'services-front'
        script: './lib/front/front.js'
        args: [8000, BASES, OPTS]
        watch: ['./lib/front']
    }
    {
        name: 'services-api'
        script: './lib/api/api-service.js'
        args: [8001, BASES, OPTS]
        watch: ['./lib/api']
    }
    {
        name: 'services-members'
        script: './lib/members/members-service.js'
        args: [BASES, OPTS]
        watch: ['./lib/members']
    }
]

module.exports = services