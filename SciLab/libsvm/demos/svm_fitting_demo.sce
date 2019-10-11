N = 1000;
M = 1;
t = rand(N,1,'norm');


m = 1//:10:100;
for M = m
x = [t];
for ii=1:M-1
    x = [x  t+ii*rand(N,1,'norm')/2];
end

//x = normalize(x);

//function data = normalize(d)
// scale before svm
// the data is normalized so that max is 1, and min is 0
//x = (x -repmat(min(x,'r'),size(x,1),1)).*repmat((1 ./(max(x,'r')-min(x,'r'))),size(x,1),1);

x=libsvm_scale(x,[0 1]);

// t1 = randn(N,1);
// t2 = randn(N,1);
// x = [t1 t2];
// y = 3*t1 - 5*t2;
y = 2*t + rand(N,1,"norm")/2 + 7;

// corrcoef([x y]);
// Mathematical definition of Pearson's product moment correlation coefficient
//r = sum((x-mean(x)).*(y-mean(y)))./sqrt(sum((x-mean(x)).^2)*sum((y-mean(y)).^2));  
// 
// b= glmfit(x,y);
for ii = 1
    for jj=1
        model = libsvm_svmtrain(y(1:N/2),x(1:N/2,:),'-s 4 -t 2 -n ' +string(ii/2)+ ' -c ' +string(1));
        zz=libsvm_svmpredict(y(N/2+1:$),x(N/2+1:$,:),model);
        xtmp=zz;ytmp=y(N/2+1:$);
        //tmp = corrcoef(zz, y(N/2+1:$));
        tmp = sum((xtmp-mean(xtmp)).*(ytmp-mean(ytmp)))./sqrt(sum((xtmp-mean(xtmp)).^2)*sum((ytmp-mean(ytmp)).^2));  
        r(1+(M-1)/10) = tmp(1);
    end
end

end

w = model.SVs' * model.sv_coef
b = -model.rho

//scf();clf();plot(m, r, 'ro-');xlabel('# of dimension'); ylabel('r')



scf();clf();
plot(x(1:N/2,:), y(1:N/2), 'b.');
plot(x(N/2+1:$,:), zz, 'r.');
xlabel('x')
ylabel('y')
legend('training','test')

//scf();clf(); plot(zz, y(N/2+1:$), '.'); 
//figure('color','w'); plot(zz - y(N/2+1:$), '.')







