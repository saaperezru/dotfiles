var gulp = require('gulp');
var browserSync = require('browser-sync').create();
var spawn = require('child_process').exec;
var reload = browserSync.reload;
var shell = require('gulp-shell')
var through = require('through2');

var rmdGlobPattern = './*.Rmd'

function rmarkdownFile(filename) {
    return () => gulp.src(filename, {read: false})
        .pipe(shell(
            [`R --slave -e "library(rmarkdown); render('<%= file.path %>', output_dir='./dist');"`], 
            verbose=true));
}

function rmarkdownWatch(filename, gulp) {
  return gulp.watch(filename, {events: ["change"], delay:1000}, rmarkdownFile(filename))
}

gulp.task('default', gulp.series(rmarkdownFile(rmdGlobPattern), function bSync() {
  browserSync.init({ 
      server: {
        baseDir: "./dist/",
        directory: true
      }
  })
  gulp.watch('./dist/*.html').on('change', reload)
  gulp.src(rmdGlobPattern).pipe(through.obj(function(file, encoding, callback) {
    rmarkdownWatch(file.path, gulp);
    callback(null, console.log);
  }))
  gulp.watch(rmdGlobPattern).on('add', ({path}) => rmarkdownWatch(path))
}));
