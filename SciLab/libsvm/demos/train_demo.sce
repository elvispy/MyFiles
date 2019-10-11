
mode(1);lines(0);


    
// Welcome to the libsvm Toolbox for Scilab 
// This demonstration  shows how importand the correct scaling is for classification
//
// Press any key to continue...
 
halt('Press return'); clc;
    
// We are using a demo dataset from  http://www.csie.ntu.edu.tw/~cjlin/libsvmtools/datasets
// Preprocessing: Original data: an application on traffic light signals from Georges Bonga at University of Applied Sciences, Berlin.     
//  # of classes: 6 
//  # of data: 300 / 312 (testing)
//  # of features: 10
// We can load the data using readsparse
    
[label_vector, instance_vector] = libsvmread(fullfile(libsvm_getpath(),"demos","svmguide4"));
[label_vector_test, instance_vector_test] = libsvmread(fullfile(libsvm_getpath(),"demos","svmguide4.t"));

// Press any key to continue...
halt('Press return');

// At first we will train and test the classificator without any scaling
model=libsvm_svmtrain(label_vector,instance_vector,'-s 1 -c 1 -t 0 -d 1 -q');

[label,acc,prob_est]=libsvm_svmpredict(label_vector_test,instance_vector_test,model);
disp("Accuracy: "+string(acc(1)));

// The result is realy bad
// Press any key to continue...
halt('Press return');

// In next step we will scale the traindataset to [0,1] and then we scale the test dataset seperatlly to [0,1]
instance_vector_scale=libsvm_scale(instance_vector,[0 1]);
model=libsvm_svmtrain(label_vector,instance_vector_scale,'-s 1 -c 1 -t 0 -d 1 -q');

instance_vector_test_sc=libsvm_scale(instance_vector_test,[0 1]);
[label,acc,prob_est]=libsvm_svmpredict(label_vector_test,instance_vector_test_sc,model);
disp("Accuracy: "+string(acc(1)));


// The result is even worser then without scaling
// Press any key to continue...
halt('Press return'); 

// In next step we will scale the traindataset to [0,1] and then use the same scaling for the test dataset
[instance_vector_scale,scale_factor]=libsvm_scale(instance_vector,[0 1]);
model=libsvm_svmtrain(label_vector,instance_vector_scale,'-s 1 -c 1 -t 0 -d 1 -q');


instance_vector_test_sc=libsvm_scale(instance_vector_test,scale_factor);
[label,acc,prob_est]=libsvm_svmpredict(label_vector_test,instance_vector_test_sc,model);
disp("Accuracy: "+string(acc(1)));


// The result is now good. This shows the importants of correct scalling

