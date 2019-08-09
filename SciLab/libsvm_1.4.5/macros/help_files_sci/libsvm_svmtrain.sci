function model = libsvm_svmtrain(training_label_vector, training_instance_matrix, libsvm_options)
// trains a svm model
// Calling Sequence
// model = libsvm_svmtrain(training_label_vector, training_instance_matrix);
// model = libsvm_svmtrain(training_label_vector, training_instance_matrix,libsvm_options);
// crossvalidationResult = libsvm_svmtrain(training_label_vector, training_instance_matrix,".. -v n");
// Parameters
// libsvm_options:
// s svm_type : set type of SVM (default 0)
// 0 : C-SVC (class seperation)
// 1 : nu-SVC (nu - classification)
// 2 : one-class SVM (one-class-classification)
// 3 : epsilon-SVR (epsilon - regression)
// 4 : nu-SVR (nu - regression)
// -t kernel_type : set type of kernel function (default 2)
// 0 -- linear: u'*v
// 1 -- polynomial: (gamma*u'*v + coef0)^degree
// 2 -- radial basis function: exp(-gamma*|u-v|^2)
// 3 -- sigmoid: tanh(gamma*u'*v + coef0)
// 4 -- precomputed kernel: (kernel values in training_instance_matrix)
// -d degree : set degree in kernel function (default 3)
// -g gamma : set gamma in kernel function (default 1/num_features)
// -r coef0 : set coef0 in kernel function (default 0)
// -c cost : set the parameter C of C-SVC, epsilon-SVR, and nu-SVR (default 1)
// -n nu : set the parameter nu of nu-SVC, one-class SVM, and nu-SVR (default 0.5)
// -p epsilon : set the epsilon in loss function of epsilon-SVR (default 0.1)
// -m cachesize : set cache memory size in MB (default 100)
// -e epsilon : set tolerance of termination criterion (default 0.001)
// -h shrinking : whether to use the shrinking heuristics, 0 or 1 (default 1)
// -b probability_estimates : whether to train a SVC or SVR model for probability estimates, 0 or 1 (default 0)
// -wi weight : set the parameter C of class i to weight*C, for C-SVC and nu-SVC (default 1)
// -v n : n-fold cross validation mode
// -q : quiet mode (no outputs)
//
// model structure:
//  model.Parameters: parameters
//  model.nr_class: number of classes; = 2 for regression/one-class svm
//  model.totalSV: total #SV
//  model.rho: -b of the decision function(s) wx+b
//  model.Label: label of each class; empty for regression/one-class SVM
//  model.sv_indices: sv_indices[0,...,nSV-1] are values in [1,...,num_traning_data] to indicate SVs in the training set
//  model.ProbA: pairwise probability information; empty if -b 0 or in one-class SVM
//  model.ProbB: pairwise probability information; empty if -b 0 or in one-class SVM
//  model.nSV: number of SVs for each class; empty for regression/one-class SVM
//  model.sv_coef: coefficients for SVs in decision functions
//  model.SVs: support vectors
//
// Cross validation results:
// crossvalidationResult: [Cross Validation Accuracy, Positive Cross Validation Accuracy, Negative Cross Validation Accuracy]
// Description
// svm types:
//
// Class separation (-s 0): optimal separating hyperplane between the two classes by maximizing the margin between the classes’ closest points
//the points lying on the boundaries are called support vectors, and the middle of the margin is our optimal separating hyperplane
//
//nu-Classification (-s 1): this model allows for more control over the number of support vectors by specifying an additional parameter (-n nu) which approximates the fraction of support vectors.
//
//one-class-classification ( -s 2): this model tries to ﬁnd the support of a distribution and thus allows for outlier/novelty detection
//
// epsilon-regression ( -s 3): here, the data points lie in between the two borders of the margin which is maximized under suitable conditions to avoid outlier inclusion.
//
// nu-regression ( -s 4): With one additional parameter (-n nu)  which approximates the fraction of support vectors
//
//
// Crossvalidation:
//
// to assess the quality of the training result, a k-fold cross-classiﬁcation on the training data can be performed by setting the parameter
// (-v ) to n (default: 0). This option -v randomly splits the data into n parts and calculates crossvalidation accuracy/mean squared error on them.
// The returned model is just a vector: [Cross Validation Accuracy, Positive Cross Validation Accuracy, Negative Cross Validation Accuracy].
//
// Scaling:
//
// Scale your data. For example, scale each column of the instance matrix to [0,1] or [-1,+1].
//
// Output:
//
// The 'svmtrain' function returns a model which can be used for future
//prediction.  It is a structure and is organized as [Parameters, nr_class,
//totalSV, rho, Label, ProbA, ProbB, nSV, sv_coef, SVs]:
//
// If you do not use the option '-b 1', ProbA and ProbB are empty
//matrices
// Examples
// label_vector=[zeros(20,1);ones(20,1)];
// instance_matrix = [rand(20,2); -1*rand(20,2)];
// model=libsvm_svmtrain(label_vector,instance_matrix);
//
// [pred,acc,dec]=libsvm_svmpredict(label_vector,instance_matrix,model);
//See also
//libsvm_svmpredict
// Authors
// Chih-Chung Chang
// Chih-Jen Lin
// Holger Nahrstaedt
