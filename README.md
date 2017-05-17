# vim-cmake v0.1.0

`vim-cmake` is a Vim plugin that makes working with CMake easier. It provides
functions to automatically find the build directory and the source root, as well
as commands to configure and build a project.

# Usage

## Commands

- `:CMakeConfigure [ <build_dir> ]` - Find the build directory (optionally
    specified as an argument), and configure and generate the makefiles.
- `:CmakeBuild[!] [ <target> ]` - Builds the project in a previously
    configured build directory. A given argument specifies a specific target to
    build.  An exclamation mark will clean the build first.

## Variables

- `g:cmake_build_dir` - Build directory. If not found, searches up the tree for
    something with the same name (or build, if not set). Set by commands and
    functions to the absolute path.
- `g:cmake_source_dir` - Source directory. If not found, searches up the tree
    for `CMakeLists.txt`, taking the one closest to root. This allows for proper
    handling of subdirectories. Set by commands and functions to the absolute
    path.
- `g:cmake_generator` - Generator (e.g. Ninja) used to generate makefiles.
- `g:cmake_build_type` - Type of build (e.g. Release/Debug).
- `g:cmake_c_compiler` - C compiler
- `g:cmake_compiler` - Compiler to use for `g:cmake_cxx_compiler` and
    `g:cmake_c_compiler` if they are not set.
- `g:cmake_cxx_compiler` - C++ compiler
- `g:cmake_install_prefix` - Location to install when building `install` target.
- `g:cmake_build_shared` - Whether to build shared libraries or not

## Functions

- `cmake#source_dir()` - Finds the source directory, returning it. Also sets
    `g:cmake_source_dir` to the absolute path of it.
- `cmake#build_dir()` - Similarly, but for the build directory. See
    `g:cmake_build_dir`.
- `cmake#configure([ path ])` - Function form of `:CMakeConfigure`.
- `cmake#build(clean, [ target ])` - Function form of `:CMakeBuild`.
- `cmake#build_command(clean, target)` - Get the command to build. Use a blank
    string as `target` to build the whole project. This can be used for
    `&makeprg` to set the make command.

# Installation

## Pathogen

Clone (or add a submodule) this repo into `vimfiles/bundle`.

