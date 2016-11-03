SenecaPromisified = require 'seneca-promisified'

module.exports = (options) ->
    seneca = new SenecaPromisified @
    seneca.add 'role:api,cmd:members', (msg) ->
        out = await @act 'role:mesh,get:members'
