" CMake functions

function! s:sh_escape(str)
	return '"' . substitute(a:str, '[\"]', '\\\0', 'g') . '"'
endfunction

function! cmake#build_dir()
	let path = get(g:, 'cmake_build_dir', 'build')
	let location = finddir(path, '.;')
	let g:cmake_build_dir = (location == '') ? '' : fnamemodify(location, ':p')
	return g:cmake_build_dir
endfunction

function! cmake#source_dir()
	if !exists('g:cmake_source_dir') || g:cmake_source_dir == ''
		let path_bits = map(split(getcwd(), '/'), {i,x -> substitute(x, ',', '\,', 'g') })
		let search_paths = map(copy(path_bits), {i,x -> join(path_bits[:i], '/') })
		let path = globpath(join(search_paths, '/,'), 'CMakeLists.txt')
		let g:cmake_source_dir = (path == '') ? '' : fnamemodify(path . '/..', ':p')
	else
		let g:cmake_source_dir = fnamemodify(g:cmake_source_dir, ':p')
	endif
	return g:cmake_source_dir
endfunction

function! cmake#configure(...)
	if a:0 > 1
		echoe 'cmake#configure(): too many arguments'
		return
	endif

	let g:cmake_build_dir = a:0 == 0 ? cmake#build_dir() : a:1
	if g:cmake_build_dir == ''
		echoe 'cmake.vim: cannot find the build directory!'
		return
	endif

	let g:cmake_source_dir = cmake#source_dir()
	if g:cmake_source_dir == ''
		echoe 'cmake.vim: cannot find the source directory!'
		return
	endif

	let args = []
	" CMake makefile generator
	if exists('g:cmake_generator')
		let args += [ '-G' . s:sh_escape(g:cmake_generator) ]
	endif
	" CMake install location
	if exists('g:cmake_install_prefix')
		let args += [ '-DCMAKE_INSTALL_PREFIX:FILEPATH=' . s:sh_escape(g:cmake_install_prefix) ]
	endif
	" Build config (Release/Debug/etc.)
	if exists('g:cmake_build_type')
		let args += [ '-DCMAKE_BUID_TYPE:STRING=' . s:sh_escape(g:cmake_build_config) ]
	endif
	" C++ compiler
	if exists('g:cmake_cxx_compiler')
		let args += [ '-DCMAKE_CXX_COMPILER:FILEPATH=' . s:sh_escape(g:cmake_cxx_compiler) ]
	elseif exists('g:cmake_compiler')
		let args += [ '-DCMAKE_CXX_COMPILER:FILEPATH=' . s:sh_escape(g:cmake_compiler) ]
	endif
	" C compiler
	if exists('g:cmake_c_compiler')
		let args += [ '-DCMAKE_C_COMPILER:FILEPATH=' . s:sh_escape(g:cmake_c_compiler) ]
	elseif exists('g:cmake_compiler')
		let args += [ '-DCMAKE_C_COMPILER:FILEPATH=' . s:sh_escape(g:cmake_compiler) ]
	endif
	" Shared libs
	if exists('g:cmake_build_shared')
		let args += [ '-DBUILD_SHARED_LIBS:BOOL=' . (g:cmake_compiler ? 'TRUE' : 'FALSE') ]
	endif

	let args = [ 'cmake' ] + args + [ s:sh_escape(g:cmake_source_dir) ]
	let cmd = join(args, ' ')

	exe 'AsyncRun' ('-cwd=' . fnameescape(g:cmake_build_dir)) cmd
	copen
endfunction

function! cmake#build_command(clean, target)
	let g:cmake_build_dir = cmake#build_dir()
	if g:cmake_build_dir == ''
		echoe 'cmake.vim: cannot find the build directory!'
		return
	endif

	let cmd = 'cmake --build ' . s:sh_escape(g:cmake_build_dir)
	if a:clean
		let cmd .= ' --clean-first'
	endif
	if a:target != ''
		let cmd .= ' --target ' . s:sh_escape(a:target)
	endif
	return cmd
endfunction

function! cmake#build(clean, ...)
	let cmd = cmake#build_command(a:clean, get(a:, 1, ''))
	exec 'AsyncRun' cmd
	copen
endfunction
