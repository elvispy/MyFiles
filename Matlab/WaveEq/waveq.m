%This is a scipt to solve second order wave equation with a function
%f_tt = f_xx - P(x, t)

clear;
clc;
tic();


N = 100; %Number of non-trivial points in the spatial coordinate
delx = 1/(N+1); %Delta x in the interval 
r = 0.5; %ratio delt/delx

u = zeros(N, 3*ceil(N/r)); %u(x, t) is the solution, column being itme fixed
T = size(u);
T = T(2); %One T is equal to one unit of time 
I_r = sparse(diag(ones(N, 1) * 4/(r*r))); %identity matrix
M = 50 * (T / ceil(N/r)); %Number of graphs to show in the plotting, 50 per unit time

%K matrix of the system
K = sparse(diag(ones(N, 1) * 2) - diag(ones(N-1, 1), 1)- diag(ones(N-1, 1), -1)); 

%Here goes the pressure definition
sup = 0.3;
peak = 0.05;
P = zeros(N, T);

for j = floor(N/2- sup * N/2) + 1:floor(N/2 + sup*N/2)
    for k = floor(T/2- sup * T/2) + 1:floor(T/2 + sup*T/2)
        aux1 = (j - N/2)*pi/(sup * N);
        aux2 = (k - T/2)*pi/(sup * T);
        P(j, k)  = cos(aux1) * cos(aux2) * peak ;
    end
end


%for j = floor(N/2- sup * N/2) + 1:floor(N/2 + sup*N/2)
%    for k = 1:2
%        aux2 = (j - N/2)*pi/(sup * N);
%        u(j, k) = cos(aux2) ^ 2;
%    end
%end

%inver = inv(I_r + K);

for n = 2:T-1 
    u(:, n+1) = (I_r + K)\(2 * (I_r - K) * u(:, n) - (I_r + K) * u(:, n-1) ...
        - P(:, n+1) - 2 * P(:, n) - P(:, n-1));
    
end


%Now comes the plotting part
hold off;
for i=1:M

    plot(linspace(0, 1, N),u(:, floor(T/M) * (i-1) + 1));
    axis([0 1 -30 30])
    pause(0.05);
end

disp("Elapsed time")
disp(toc());
disp("-------------")
