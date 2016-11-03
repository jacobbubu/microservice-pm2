module.exports = (options) ->
    seneca = @
    seneca.add 'cmd:delay', (msg, done) ->
        console.log 'delay-logic', process.pid
        seneca = @
        start = Date.now()
        timeout = msg.timeout ? 100
        setTimeout ->
            done null, {
                msg: "Time taken: #{Date.now() - start}ms"
                pid: process.pid
            }
        , timeout