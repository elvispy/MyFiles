filename = uigetfile("*.csv", 'all CSV files')
a1 = csvRead(filename)

[b1, renum] = gsort(a1(:,3));

a1 = a1(renum, :);

label_vector = a1(:,3);

instance_matrix = [a1(:,1), a1(:, 2)];

model = libsvm_svmtrain(label_vector, instance_matrix);


[pred, accuracy, dec] = libsvm_svmpredict(label_vector, instance_matrix, model)


x1 = linspace(-4, 3);
x2 = linspace(-3, 4);

rho = model.rho;
gamma = model.Parameters(4);
sv_coef = model.sv_coef;
SVs = model.SVs;
nSV = length(sv_coef);
f = ones(100, 100);

for k = 1:100
    for i  = 1:100
        mat = ones(nSV, 2);
        mat(:,1) = x1(k);
        mat(:,2) = x2(i);
        mat =mat - SVs;
        mat = (mat(:,1).^2) + (mat(:,2).^2);
        a = (sv_coef'*exp(-gamma*mat))-rho;
        
       f(i,k) = a;
    end
end

