"use strict"

# -- DEPENDENCIES --------------------------------------------------------------
gulp    = require 'gulp'
coffee  = require 'gulp-coffee'
concat  = require 'gulp-concat'
flatten = require 'gulp-flatten'
header  = require 'gulp-header'
uglify  = require 'gulp-uglify'
gutil   = require 'gulp-util'
pkg     = require './package.json'

# -- FILES ---------------------------------------------------------------------
assets = './'
spec   = './build/'
source =
  coffee: 'source/*.coffee'
  test  : 'spec/index.coffee'
  spec  : 'spec/spec.coffee'

banner = [
  '/**'
  ' * <%= pkg.name %> - <%= pkg.description %>'
  ' * @version v<%= pkg.version %>'
  ' * @link    <%= pkg.homepage %>'
  ' * @author  <%= pkg.author.name %> (<%= pkg.author.site %>)'
  ' * @license <%= pkg.license %>'
  ' */'
  ''].join('\n')

# -- TASKS ---------------------------------------------------------------------
gulp.task 'coffee', ->
  gulp.src(source.coffee)
    .pipe(concat(pkg.name + '.coffee'))
    .pipe(coffee().on('error', gutil.log))
    .pipe(uglify({mangle: false}))
    .pipe(header(banner, {pkg: pkg}))
    .pipe(gulp.dest(assets))

gulp.task 'test', ->
  gulp.src(source.test)
    .pipe(concat(pkg.name + '.test.coffee'))
    .pipe(coffee().on('error', gutil.log))
    .pipe(uglify({mangle: false}))
    .pipe(header(banner, {pkg: pkg}))
    .pipe(gulp.dest(spec))

gulp.task 'init', ->
  gulp.run(['coffee', 'test'])

gulp.task 'default', ->
  gulp.watch(source.coffee, ['coffee'])
  gulp.watch(source.test, ['test'])
