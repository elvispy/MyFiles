mode(1);lines(0);

   
// Welcome to the libsvm Toolbox for Scilab 
// 
// Please wait, demo is working ....
mode(-1);
//Test libsvm's performance
result = [];
for N = [100 500 1000 ]
    for dim = [3 6 10 20 50 100]

    l = [ones(N,1); -ones(N,1)]; // label
    d = [l/2 + rand(2*N,1,'norm')/1  l-rand(2*N,1,'norm')/1 rand(2*N, dim-2,'norm')]; // data

    tic();model = libsvm_lintrain(l,sparse(d),'-s 1 -q');x = toc();
    tic();[predicted_label, accuracy, decision_values] = libsvm_linpredict(l, sparse(d), model);y = toc();
    
    result = [result; [N dim x y]];
    
    end
end

disp(result)

//
scf();clf();
plot(result(result(:,1)==100,2),result(result(:,1)==100,3));
plot(result(result(:,1)==500,2),result(result(:,1)==500,3),'r');
plot(result(result(:,1)==1000,2),result(result(:,1)==1000,3),'c');
legend("N=100","N=500","N=1000");
xlabel("dim");
ylabel("Training time [sec]");
title("libsvm performance");



// // calculate w and b
// w = model.SVs' * model.sv_coef;
// b = -model.rho;
// 
// if model.Label(1) == -1
//   w = -w;
//   b = -b;
// end
// disp(w)
// disp(b)


// scf();clf();
// // plot the boundary line
//  x = [min(d(:,1)):.01:max(d(:,1))];
//  y = (-b - w(1)*x ) / w(2);
// // hold on;
//  plot(x,y)
// 
// 
