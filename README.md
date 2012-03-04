This project is a series of testing for EditorConfig Core. Please have
[cmake]() installed before using this project.

After installing cmake, switch to the root dir of this project, and execute:

    cmake -DEDITORCONFIG_CMD=the_editorconfig_core_cmd_you_want_to_test

After that, if testing files are generated successfully, execute `ctest .` to
start testings.


[cmake]: http://www.cmake.org
