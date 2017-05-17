" CMake command declarations

command! -nargs=? -bar CMakeConfigure call cmake#configure(<args>)
command! -nargs=? -bang -bar CMakeBuild call cmake#build(<bang>0, <args>)
