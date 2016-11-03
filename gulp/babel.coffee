path = require 'path'
gutil = require 'gulp-util'
through = require 'through2'
applySourceMap = require 'vinyl-sourcemaps-apply'
replaceExt = require 'replace-ext'
babel = require 'babel-core'

PluginError = gutil.PluginError
PluginName = 'gulp-babel'

replaceExtension = (fp) ->
    if path.extname(fp) then replaceExt(fp, '.js') else fp

module.exports = (opts = {}) ->
    through.obj (file, enc, cb) ->
        return cb null, file if file.isNull()

        if file.isStream()
            return cb new PluginError(PluginName, 'Streaming not supported')

        try
            fileOpts = Object.assign {}, opts, {
                filename: file.path
                filenameRelative: file.relative
                sourceMap: Boolean(file.sourceMap)
                sourceFileName: file.relative
                sourceMapTarget: file.relative
            }

            res = babel.transform file.contents.toString('utf8'), fileOpts

            if file.sourceMap and res.map
                res.map.file = replaceExtension res.map.file
                applySourceMap file, res.map

            if !res.ignored
                file.contents = new Buffer res.code
                file.path = replaceExtension file.path

            file.babel = res.metadata
            this.push file

        catch err
            this.emit 'error', new PluginError PluginName, err, {
                fileName: file.path
                showProperties: false
            }

        cb()
