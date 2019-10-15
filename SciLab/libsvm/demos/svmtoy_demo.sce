mode(1);lines(0);


    
// Welcome to the libsvm Toolbox for Scilab 
// This demonstration  shows the output of svmtoy for plotting a two-class classification boundary of the 2-D data
//
// Press any key to continue...
 
halt('Press return'); clc;
//
// We are generating a random dataset 
instance_matrix = [rand(20,2); -1*rand(20,2)];
label_vector=[zeros(20,1);ones(20,1)];

// Press any key to continue...
halt('Press return');
//
scf(1);clf(1);
libsvm_toy(label_vector, instance_matrix,"-c 1000 -g 0.5",[-1 0 1])


