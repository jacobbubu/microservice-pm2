path = require 'path'
coffee = require 'coffee-script'
through = require 'through2'
gutil = require 'gulp-util'
applySourceMap = require 'vinyl-sourcemaps-apply'

PluginError = gutil.PluginError
PluginName = 'gulp-coffee'

replaceExtension = (path) ->
    path = path.replace /\.coffee\.md$/, '.litcoffee'
    gutil.replaceExtension path, '.js'

module.exports = (opt) ->
    through.obj (file, enc, cb) ->
        return cb(null, file) if file.isNull()
        if file.isStream()
            return cb new PluginError(PluginName, 'Streaming not supported')

        src = file.contents.toString 'utf8'
        dest = replaceExtension file.path

        try
            options = Object.assign {
                bare: false
                header: false
                sourceMap: !!file.sourceMap
                sourceRoot: false
                literate: /\.(litcoffee|coffee\.md)$/.test(file.path)
                filename: file.path
                sourceFiles: [file.relative]
                generatedFile: replaceExtension file.relative
            }, opt

            data = coffee.compile src, options
        catch err
            return cb new PluginError PluginName, err, {
                fileName: file.path
                showProperties: false
            }
            # this.emit 'error', new PluginError PluginName, err, {
            #     fileName: file.path
            #     showProperties: false
            # }
            # return cb()

        if data?.v3SourceMap and file.sourceMap
            applySourceMap file, data.v3SourceMap
            file.contents = new Buffer data.js
        else
            file.contents = new Buffer data

        file.path = dest
        cb null, file

