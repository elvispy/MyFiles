function [path]= libsvm_getpath()
// Returns the path to the current module.
// Calling Sequence
//   path = libsvm_getpath ( )
//  Parameters
// path : a 1-by-1 matrix of strings, the path to the current module.
//   Examples
//    path = libsvm_getpath ( )
// Authors
// Holger Nahrstaedt
	
	[lhs, rhs] = argn()
	//apifun_checkrhs ( "libsvm_getpath" , rhs , 0:0 )
	//apifun_checklhs ( "libsvm_getpath" , lhs , 1:1 )
	
	path = get_function_path("libsvm_getpath")
	path = fullpath(fullfile(fileparts(path),".."));
endfunction
