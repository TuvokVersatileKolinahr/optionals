# Load all required libraries.
fs          = require 'fs'
del         = require 'del'
gulp        = require 'gulp'
path        = require 'path'
nconf       = require 'nconf'
gulpif      = require 'gulp-if'
sass        = require 'gulp-sass'
debug       = require 'gulp-debug'
underscore  = require 'underscore'
concat      = require 'gulp-concat'
coffee      = require 'gulp-coffee'
jshint      = require 'gulp-jshint'
rename      = require 'gulp-rename'
replace     = require 'gulp-replace'
plumber     = require 'gulp-plumber'
coffeelint  = require 'gulp-coffeelint'
cssmin      = require 'gulp-minify-css'
minifyHTML  = require 'gulp-minify-html'
prefix      = require 'gulp-autoprefixer'
stylish     = require 'coffeelint-stylish'

# Setup nconf to use (in-order):
#   1. Command-line arguments
#   2. Environment variables
#   3. A file located at 'path/to/config.json'
#
nconf.argv()
     .env()
     .file({ file: 'local_settings.json' });

# Set some options for debugging
debug_opts = {}
debug_opts.verbose = nconf.get('v')? || nconf.get('verbose')?

# Also require the webserver and live-reload related tasks
require './gulp-serve.coffee'

#error handling
handleError = (err) ->
  console.log err.toString
  this.emit 'end'
  return

# Create the prerequisites for the actual app
# 
# depends on:
#   vendor
#   app
gulp.task 'scripts', ['vendor', 'app']

gulp.task 'vendor', ->
  bowerFile = require './bower.json'
  bowerDir = './bower_components'
  bowerPackages = []

  underscore.each bowerFile.dependencies, (version, name) ->
    dir = bowerDir + '/' + name + '/'
    bowerDepFile = require dir + 'bower.json'
    if debug_opts.verbose
      console.log bowerDepFile.main
      console.log dir
    if typeof bowerDepFile.main == 'object'
      files = bowerDepFile.main
      file = dir + files[0]
    else
      file = dir + bowerDepFile.main
    minfile = file.substring(0, file.length - 3) + '.min.js'
    if debug_opts.verbose
      console.log "file", file
      console.log "minfile", minfile

    if fs.existsSync minfile 
      # use min version
      if debug_opts.verbose
        console.log "use min"
      bowerPackages.push minfile
    else
      # unminified
      if debug_opts.verbose
        console.log "use file"
      bowerPackages.push file
    return

  # push anything in src/javascript/vendor to the array
  p = './src/javascript/vendor'

  if fs.existsSync p
    files = fs.readdirSync p
    underscore.each files, (file) ->
      if debug_opts.verbose
        console.log "%s (%s)", file, path.extname file
      bowerPackages.push p + "/" + file
      return
    
  # console.log bowerPackages 
  gulp.src bowerPackages
    .pipe plumber()
    .pipe concat('vendor.js')
    .pipe gulp.dest 'dist/static/js'

# app task - concatenates all application code into app.js
gulp.task 'app', ->
  gulp.src ['src/javascript/app.js',
            'src/javascript/directives/**/*',
            'src/javascript/services/**/*',
            'src/javascript/controllers/**/*',
            'src/modules/**/*.coffee'
           ]
    .pipe plumber()
    .pipe gulpif /[.]coffee$/, coffee({bare: true})
    .on('error', handleError)
    .pipe replace '__OAUTH_TOKEN__', nconf.get 'oauth_token'
    .pipe concat('app.js')
    .pipe gulp.dest 'dist/static/js'


# Create CSS - compiles the sass sources into styles.css
gulp.task 'css', ->
  gulp.src 'src/scss/styles.scss'
    .pipe plumber()
    .pipe sass()
    .pipe prefix "> 1%"
    .pipe cssmin keepSpecialComments: 0
    .pipe gulp.dest 'dist/static/css'

# Create HTML
# 
# depends on:
#   minify-html
gulp.task 'html', ['minify-html']

# minify-html task - minifies html sources
gulp.task 'minify-html', ->
  opts = {empty:true,spare:true}
  gulp.src ['src/**/*.html']
    .pipe plumber()
    .pipe minifyHTML(opts)
    .pipe gulp.dest 'dist'

# Copy static resources using streams.
#
# depends on:
#   fonts
#   visuals
gulp.task 'resources', ['fonts', 'visuals']

gulp.task 'fonts', ->
  gulp.src 'src/fonts/*'
    .pipe plumber()
    .pipe gulp.dest 'dist/static/css/fonts'

gulp.task 'visuals', ->
  gulp.src 'src/visuals/**/*'
    .pipe plumber()
    .pipe gulp.dest 'dist/static'

# watch task - watches changes in files and runs tasks on changes
# 
# depends on:
#   css
#   scripts
#   lint
#   clint
#   html
gulp.task 'watch', ->
  gulp.watch "src/scss/*.scss", ['css']
  gulp.watch "src/**/*.js", ['scripts', 'lint']
  gulp.watch "src/**/*.coffee", ['scripts', 'clint']
  gulp.watch "src/**/*.html", ['html']
  #gulp.watch 'src/img/**/*', ['images']

# coffee lint - checks the produced coffee files
gulp.task 'clint', ->
  gulp.src './src/**/*.coffee'
      .pipe coffeelint()
      .pipe coffeelint.reporter()

# lint task - checks the produced javascript
gulp.task 'lint', ->
  gulp.src ['src/javascript/**/*.js']
    .pipe plumber()
    .pipe jshint()
    .pipe jshint.reporter stylish

# Remove generated sources
gulp.task 'clean', ->
  del.sync ['dist/**']

# build task - builds all sources
#
# depends on:
#   clean
gulp.task 'build', ['clean'], ->
  gulp.start 'css', 'scripts', 'html', 'resources'

# deploy task - copies the dist contents to a location
#
# depends on:
#   build
# gulp.task 'deploy', ['build'], ->
#   console.log 'Copy files to webserver'
#   gulp.src 'dist/**/*'
#     .pipe plumber()
#     .pipe gulp.dest 'D:/Development/pss2-head/Servers/tomcat/webapps/locals'
#     # .pipe gulp.dest 'tmp/testgulptarget'

gulp.task 'deploy', ->
  gulp.start 'css', 'scripts', 'html', 'resources'

# Default task call every tasks created so far.
gulp.task 'default', ['scripts', 'css', 'html', 'resources']