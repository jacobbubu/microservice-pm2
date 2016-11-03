BASES = (process.env.BASES ? process.argv[2] ? '').split(',')

require('seneca') {
    tag: 'members',
    # internal: {logger: require('seneca-demo-logger')},
    debug: short_logs: true
    transport: type: 'tcp'
}
.use './members-logic'
.use 'mesh',
    pin: 'role:api,cmd:members'
    bases: BASES
.ready -> console.log this.id
