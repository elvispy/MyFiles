function libsvmwrite('filename', label_vector, instance_matrix);
//   writes sparse matrix to a file in LIBSVM format
// Calling Sequence
//	libsvmwrite(filename, label_vector, instance_matrix)
// Parameters
// filename : string containing the file name with or without path in which the data will be saved
// label_vector: a vector containing the group information. For a two class problem each element is either -1 or 1.  for multi class the entries are positive numbers.
// instance_matrix: a sparse matrix containing the features. Each column is a feature vector associated to the group in the coresponding entry in label_vector 
//
// Description
// The instance_matrix must be a sparse matrix. (type must be double)
// Examples
// N=1000;
//  label_vector = [ones(N/2,1); -ones(N/2,1)]; 
//  d = [label_vector/2 + rand(N,1,'norm')/1  label_vector-rand(N,1,'norm')/1 rand(N, 1,'norm')]; // data
// instance_matrix=sparse(d);
// libsvmwrite('test_data', label_vector, instance_matrix);
// 
// model = svmtrain(label_vector,d,'-t 0 -q');
//  [predicted_label, accuracy, decision_values] = svmpredict(label_vector, instance_matrix, model);
// See also
// libsvmread
// 
// Authors
// Chih-Chung Chang
// Chih-Jen Lin
// Holger Nahrstaedt
