fs = require 'fs'
pm2 = require 'pm2'
gutil = require 'gulp-util'
reduce = require 'async/reduce'
each = require 'async/each'
services = require './service-config'

PluginError = gutil.PluginError

DefaultOpts =
    watch: true
    restartDelay: 200
    mergeLogs: true
    sourceMapSupport: true

listAll = (cb) ->
    pm2.list (err, processDescriptionList) ->
        return cb err if err?
        names = processDescriptionList.filter (p) -> p.name.startsWith 'services-'
                .map (p) -> p.name
        cb null, names

start = (cb) ->
    pm2.connect true, (err) ->  # noDaemonMode = true
        if err?
            return cb new PluginError 'pm2', err, showStack: true

        listAll (err, names) ->
            if err?
                return cb new PluginError 'pm2', err, showStack: true

            each names, (name, cb) ->
                pm2.delete name, cb
            , (err) ->
                if err?
                    return cb new PluginError('pm2', err, showStack: true)

                gutil.log 'The following processed have been stopped', names

                reduce services, [], (prev, service, cb) ->
                    opts = Object.assign {}, DefaultOpts, service
                    if fs.existsSync service.script
                        pm2.start opts, cb
                    else
                        cb null, {}
                , (err, apps) ->
                    pm2.disconnect()
                    if err?
                        return cb new PluginError 'pm2', err, showStack: true
                    cb null, apps

module.exports = start