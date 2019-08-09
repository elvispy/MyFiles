function [label_vector, instance_matrix] = libsvmread('data.txt'); 
//   reads files in LIBSVM format
// Calling Sequence
//	[label_vector, instance_matrix] = libsvmread(filename); 
// Parameters
// filename : string containing the file with or without path which will be loaded
// label_vector: a vector containing the group information. For a two class problem each element is either -1 or 1. For multi class the entries are positive numbers.
// instance_matrix: a sparse matrix containing the features. Each column is a feature vector associated to the group in the coresponding entry in label_vector 
// Description
// Two outputs are labels and instances, which can then be used as inputs
// of svmtrain or svmpredict. 
// 
// 
// 
// The data files from http://www.csie.ntu.edu.tw/~cjlin/libsvmtools/datasets/ can be 
// read using libsvmread
// 
// Examples
// [heart_scale_label, heart_scale_inst] = libsvmread(fullfile(libsvm_getpath(),"demos","heart_scale"));
// See also
// libsvmwrite
// Authors
// Chih-Chung Chang
// Chih-Jen Lin
// Holger Nahrstaedt
