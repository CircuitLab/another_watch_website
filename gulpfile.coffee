gulp = require 'gulp'
gutil = require 'gulp-util'
jade = require 'gulp-jade'
stylus = require 'gulp-stylus'
nib = require 'nib'
base64 = require 'gulp-base64'
concat = require 'gulp-concat'
coffee = require 'gulp-coffee'
watch = require 'gulp-watch'
connect = require 'gulp-connect'

gulp.task 'jade', ->
  gulp.src 'src/jade/*.jade'
    .pipe jade()
    .pipe gulp.dest 'public'
    .pipe connect.reload()

gulp.task 'stylus', ->
  gulp.src 'src/stylus/*.styl'
    .pipe stylus {use: [nib()]}
    .pipe base64(
            baseDir: 'src'
            extensions: ['svg', 'png', 'jpg']
            maxImageSize: 32*1024
            debug: true
    )
    .pipe concat "main.css"
    .pipe gulp.dest 'public/css'
    .pipe connect.reload()

gulp.task 'image', ->
  gulp.src 'src/image/**'
    .pipe gulp.dest 'public/image'
    .pipe connect.reload()

gulp.task 'coffee', ->
  gulp.src 'src/coffee/*.coffee'
    .pipe coffee({ bare: true }).on 'error', gutil.log
    .pipe gulp.dest 'public/js'
    .pipe connect.reload()

gulp.task 'connect', ->
  connect.server {
    root: 'public'
    livereload: true
  }

gulp.task 'watch', ->
  gulp.watch [
    'src/jade/*.jade'
    'src/stylus/*.styl'
    'src/coffee/*.coffee'
    'src/image/**'
  ], [
    'jade'
    'stylus'
    'coffee'
    'image'
  ]

gulp.task 'default',
  [ 'connect', 'watch' ]
