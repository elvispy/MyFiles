
mode(1);lines(0);


    
// Welcome to the libsvm Toolbox for Scilab 
// This demonstration  shows how one class classification can be used for outlier detection
//
// Press any key to continue...
 
halt('Press return'); clc;
//
// We are generating a random dataset and add one outlier
x=rand(100,1);

//  outlier at pos 10
x(30)=1.2;

// Press any key to continue...
halt('Press return');
//
// At first we will train and test the dataset. We set the classifier to one-class SVM (-s 2)
model=libsvm_svmtrain(ones(x),x,'-s 2');
//
[label,acc,dec_val]=libsvm_svmpredict(ones(x),x,model);
//

// Now we can check the decision_values
// Press any key to continue...
halt('Press return');

scf();clf();
subplot(211)
plot(x);
xgrid(1);

subplot(212)
plot(dec_val);
xgrid(1);
xtitle("There seems to be an outlier at pos 30");


