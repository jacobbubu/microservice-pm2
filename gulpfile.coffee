gulp = require 'gulp'
gutil = require 'gulp-util'
watch = require 'gulp-watch'
sourcemaps = require 'gulp-sourcemaps'
plumber = require 'gulp-plumber'

coffee = require './gulp/coffee'
babel = require './gulp/babel'
pm2 = require './gulp/pm2'

piping = (from) ->
    from.pipe plumber()
        .pipe sourcemaps.init()
        .pipe coffee({ bare: true }).on('error', gutil.log)
        .pipe babel presets: ['node5']
        .pipe sourcemaps.write('.')
        .pipe gulp.dest './lib/'

gulp.task 'build', ->
    piping gulp.src './src/**/*.coffee'

gulp.task 'watch', (cb) ->
    pm2 (err) ->
        return cb err if err?
        cb null, piping(watch './src/**/*.coffee', ignoreInitial: false)

gulp.task 'default', ['build']