% test-script for VMD
%--------------- Preparation
clearvars;
%close all;
clc;
%Put your working directory here
%chdir("C:\Users\USUARIO CIAC\Documents\GITRepos\MyFiles\SciLab")

% Time Domain 0 to T
T = 3000;
fs = 1/T;
t = (1:T)/T;
freqs = 2*pi*(t-0.5-1/T)/(fs);

% center frequencies of components
f_1 = 2;
f_2 = 24;
f_3 = 288;

% modes
v_1 = (cos(2*pi*f_1*t));
v_2 = 1/4*(cos(2*pi*f_2*t));
v_3 = 1/16*(cos(2*pi*f_3*t));

% for visualization purposesu


% composite signal, including noise
f = v_1 + v_2 + v_3 + 0.1*randn(1);
f_hat = fftshift((fft(f)));

% some sample parameters for VMD
alpha = 2000;        % moderate bandwidth constraint
tau = 0;            % noise-tolerance (no strict fidelity enforcement)
K = 3;              % 3 modes
DC = 0;             % no DC part imposed 
init2 = 1;           % initialize omegas uniformly
tol = 1e-10;        %Tolerance of the method in VMD
N = 1200;            %Number of iterations before getting out
%inter = 1.D-3;
inter = pi;    %Interval of definition of the data
prec = 1e-1;        %precision in the Hilbert Marginal Spectrum decomposition




%--------------- Run actual VMD code
disp("Summary")
disp("-------------")
tic();
%[u, u_hat, omega] = VMD3(f, alpha, tau, K, DC, init, tol, N, inter);

disp("Running time  of  finding of IMFs")
disp(toc());
disp("-------------")
tic();
[u, u_hat, omega, test] = VMD(f, alpha, tau, K, DC, init2, tol, N, inter);
disp(toc());

%save('u.sod', 'u');
% disp("Running time  of  calculating HMS and HMSEE")
% disp("-------------");
% tic();
% [HMS, rango, HMSEE, omeg_k, A_k, teta_k] = HilbS(u, prec, inter);
% disp(toc());
disp("Running time of calculating HMS and HMSEE via matlab functions")
disp("------------------");
tic();

[HMSf, f, HMSEEf] = H2(u, inter);
disp(toc());
