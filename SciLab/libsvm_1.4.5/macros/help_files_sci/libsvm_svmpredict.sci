function [predicted_label, accuracy, decision_values/prob_estimates] = libsvm_svmpredict(testing_label_vector, testing_instance_matrix, model, 'libsvm_options')
// Does prediction for a calculated svm model
// Calling Sequence
// [predicted_label, accuracy, decision_values] = libsvm_svmpredict(testing_label_vector, testing_instance_matrix, model)
// [predicted_label, accuracy, decision_values] = libsvm_svmpredict(testing_label_vector, testing_instance_matrix, model, 'libsvm_options')
// Parameters
//  model: SVM model structure from svmtrain.
//   libsvm_options:-b probability_estimates: whether to predict probability estimates, 0 or 1 (default 0); one-class SVM not supported yet
//   predicted_label: SVM prediction output vector
//    accuracy: a vector with accuracy, mean squared error, squared correlation coefficient.
//    prob_estimates: If selected, probability estimate vector
//    predicted_label: vector of predicted labels
//    accuracy: a vector including accuracy (for classification), mean squared error, and squared correlation coefficient (for regression).
//    decision_values:  a matrix containing decision values or probability estimates (if '-b 1' is specified).
//    
//   Description
// 
//The third output is a matrix containing decision values or probability estimates (if '-b 1' is specified). If k is the number of classes
//in training data, for decision values, each row includes results of predicting k(k-1)/2 binary-class SVMs.  For probability estimates, you need '-b 1' for training and testing.
//
//For classification, k = 1 is a special case. Decision value +1 is returned for each testing instance,instead of an empty vector. 
//
//For probabilities, each row contains k values indicating the probability that the testing instance is in each class.
//
//Note that the order of classes here is the same as 'Label' field in the model structure.
//
//Note that for testing, you can put anything in the testing_label_vector.
//
//To use precomputed kernel, you must include sample serial number as the first column of the training and testing data (assume your kernel matrix is K, # of instances is n). Precomputed kernel requires dense matrix
//
//
// Examples
// label_vector=[zeros(20,1);ones(20,1)];
// instance_matrix = [rand(20,2); -1*rand(20,2)];
// model=libsvm_svmtrain(label_vector,instance_matrix);
// 
// [pred,accuracy,dec]=libsvm_svmpredict(label_vector,instance_matrix,model);
// disp("accuracy: "+string(accuracy(1))+" %");
// 
//  // -------------------------------------
//  //heart_scale demo
//   [heart_scale_label, heart_scale_inst] = libsvmread(fullfile(libsvm_getpath(),"demos","heart_scale"));
//   // Split Data
//   train_data = heart_scale_inst(1:150,:);
//   train_label = heart_scale_label(1:150,:);
//   test_data = heart_scale_inst(151:270,:);
//   test_label = heart_scale_label(151:270,:);
//   
//   //linear kernel
//   model_linear = libsvm_svmtrain(train_label, train_data, '-t 0');
//   [predict_label_L, accuracy_L, dec_values_L] = libsvm_svmpredict(test_label, test_data, model_linear);
//   
//   //precomputed kernel
//   model_precomputed = libsvm_svmtrain(train_label, full([(1:150)', train_data*train_data']), '-t 4');
//   [predict_label_P, accuracy_P, dec_values_P] = libsvm_svmpredict(test_label, full([(1:120)', test_data*train_data']), model_precomputed);
//   
//   disp("accuracy using linear kernel: "+string(accuracy_L(1)));
//   disp("accuracy using precomputed kernel: "+string(accuracy_P(1)));
//   
//   // -------------------------------------
//   //probability estimatation demo (you need '-b 1' for training and testing)
//   
//   [heart_scale_label, heart_scale_inst] = libsvmread(fullfile(libsvm_getpath(),"demos","heart_scale"));
//   model = libsvm_svmtrain(heart_scale_label, heart_scale_inst, '-c 1 -g 0.07 -b 1');
//   [predict_label, accuracy, prob_estimates] = libsvm_svmpredict(heart_scale_label, heart_scale_inst, model, '-b 1');
//   prob_estimates
//
// See also
// libsvm_svmtrain
// Authors
// Chih-Chung Chang
// Chih-Jen Lin
// Holger Nahrstaedt
// 

