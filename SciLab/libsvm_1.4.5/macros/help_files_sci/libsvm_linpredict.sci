function [predicted_label, accuracy, decision_values/prob_estimates] = libsvm_linpredict(testing_label_vector, testing_instance_matrix, model, 'liblinear_options','col')
// Does prediction for a calculated svm model
// Calling Sequence
// [predicted_label, accuracy, decision_values/prob_estimates] = libsvm_linpredict(testing_label_vector, testing_instance_matrix, model)
// [predicted_label, accuracy, decision_values/prob_estimates] = libsvm_linpredict(testing_label_vector, testing_instance_matrix, model,'liblinear_options')
// [predicted_label, accuracy, decision_values/prob_estimates] = libsvm_linpredict(testing_label_vector, testing_instance_matrix, model, 'liblinear_options','col')
// Parameters
// liblinear_options: -b probability_estimates: whether to predict probability estimates, 0 or 1 (default 0)
// col: if 'col' is setted testing_instance_matrix is parsed in column format, otherwise is in row format
// predicted_label:a vector of predicted labels
// accuracy: a vector with accuracy, mean squared error, squared correlation coefficient
// decision_values/prob_estimates: a matrix containing decision values or probability estimates (if '-b 1' is specified).
// Description
// 
//The third output is a matrix containing decision values or probability
//estimates (if '-b 1' is specified). If k is the number of classes
//and k' is the number of classifiers (k'=1 if k=2, otherwise k'=k), for decision values,
//each row includes results of k' binary linear classifiers. For probabilities,
//each row contains k values indicating the probability that the testing instance is in
//each class. Note that the order of classes here is the same as 'Label'
//field in the model structure.
//
// Examples
// label_vector=[zeros(20,1);ones(20,1)];
// instance_matrix = sparse([rand(20,2); -1*rand(20,2)]);
// model=libsvm_lintrain(label_vector,instance_matrix,"-q")
// [pred_label, accuracy, dec_values]=libsvm_linpredict(label_vector,instance_matrix,model);
// disp("accuracy: "+string(accuracy(1))+" %");
// 
// //---------------------
// // heart scale demo
// [heart_scale_label, heart_scale_inst] = libsvmread(fullfile(libsvm_getpath(),"demos","heart_scale"));
// model = libsvm_lintrain(heart_scale_label, heart_scale_inst, '-c 1');
// [predict_label, accuracy, dec_values] = libsvm_linpredict(heart_scale_label, heart_scale_inst, model); // test the training data
// disp("accuracy: "+string(accuracy(1))+" %");
// 
// 
//See also
//libsvm_lintrain
// Authors
// Chih-Chung Chang
// Chih-Jen Lin
// Holger Nahrstaedt
// 