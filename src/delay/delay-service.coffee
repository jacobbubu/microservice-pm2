BASES = (process.env.BASES ? process.argv[2] ? '').split(',')

require('seneca') {
    tag: 'delay',
    # internal: {logger: require('seneca-demo-logger')},
    debug: short_logs: true
    transport: type: 'tcp'
}
.use 'entity'
.use './delay-logic'
.use 'mesh',
    pin: 'cmd:delay'
    bases: BASES
.ready -> console.log this.id
