var gulp = require('gulp');
var pug = require('gulp-pug');
var browserSync = require('browser-sync')
var reload = browserSync.reload;

gulp.task('pug', function () {
  return gulp.src('src/*.pug')
    .pipe(pug())
    .pipe(gulp.dest('dist'));
});

gulp.task('pug-watch', ['pug'], reload);

gulp.task('default', ['pug'], function () {
  browserSync({ server: 'dist' }),
  gulp.watch('src/*.pug', ['pug-watch']);
});
