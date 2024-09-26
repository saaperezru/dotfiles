var gulp = require('gulp');
var browserSync = require('browser-sync').create();
var spawn = require('child_process').exec;
var reload = browserSync.reload;
var shell = require('gulp-shell')

function rmarkdown() {
    return gulp.src('*.Rmd', {read: false})
        .pipe(shell(
            [`R --slave -e "library(rmarkdown); render('<%= file.path %>', output_dir='./dist');"`], 
            verbose=true));
}

gulp.task('default', gulp.series(rmarkdown, function bSync() {
  browserSync.init({ 
      server: "./dist/"
  })
  gulp.watch('./dist/*.html').on('change', reload)
  gulp.watch('*.Rmd', {events: ["change"], delay:1000}, rmarkdown)
}));
