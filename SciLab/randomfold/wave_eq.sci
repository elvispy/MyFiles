//This is a scipt to solve second order wave equation with a function
//f_tt = f_xx - P(x, t)

clear all;
clc;
tic();


N = 100; //Number of non-trivial points in the spatial coordinate
delx = 1/(N+1); //Delta x in the interval 
r = 0.1; //ratio delt/delx

u = zeros(N, ceil(N/r)); //u(x, t) is the solution, column being itme fixed
C = size(u)(2);
I_r = sparse(diag(ones(N, 1) * 4/(r*r))); //identity matrix


//K matrix of the system
K = sparse(diag(ones(N, 1) * 2) - diag(ones(N-1, 1), 1)- diag(ones(N-1, 1), -1)); 

//Here goes the pressure definition
sup = 0.3;
peak = 1;
P = zeros(N, C);
/*
for j = int(N/2- sup * N/2) + 1:int(N/2 + sup*N/2)
    for k = int(C/2- sup * C/2) + 1:int(C/2 + sup*C/2)
        aux1 = (j - N/2)*%pi/(sup * N);
        aux2 = (k - C/2)*%pi/(sup * C);
        P(j, k)  = cos(aux1) * cos(aux2) * peak ;
    end
end
*/

for j = int(N/2- sup * N/2) + 1:int(N/2 + sup*N/2)
    for k = 1:2
        aux2 = (j - N/2)*%pi/(sup * N);
        u(j, k) = cos(aux2) ** 2;
    end
end


inver = inv(I_r + K);

for n = 2:C-1 //beware! this should depend on time also
    u(:, n+1) = inver * (2 * (I_r - K) * u(:, n) - (I_r + K) * u(:, n-1) ..
                - P(:, n+1) - 2 * P(:, n) - P(:, n-1));
end

//Now comes the plotting part
h = figure(1);
da = gda();
da.auto_clear = 'on';
da.data_bounds = [1, -1.2; N, 1];
da.filled = 'on';

for i=1:50
    da.background = 7;
    //clf();
    plot(u(:, floor(C/50) * (i-1) + 1));
    sleep(50);
end
disp("Elapsed time")
disp(toc());
disp("-------------")
