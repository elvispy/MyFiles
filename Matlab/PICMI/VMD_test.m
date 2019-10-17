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
f = v_1 + v_2 + v_3 + 0.1*rand(1, 'normal');
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
inter = 4 * pi;    %Interval of definition of the data
prec = 1e-2;        %precision in the Hilbert Marginal Spectrum decomposition




%--------------- Run actual VMD code
disp("Summary")
disp("-------------")
tic();
%[u, u_hat, omega] = VMD3(f, alpha, tau, K, DC, init, tol, N, inter);

disp("Running time  of  finding of IMFs")
disp(toc());
disp("-------------")
tic();
[u2, u_hat2, omega2, test] = VMD(f, alpha, tau, K, DC, init2, tol, N, inter);
disp(toc())

save('u2.sod', 'u2');
disp("Running time  of  calculating HMS and HMSEE")
disp("-------------");
tic();
[HMS, rango, HMSEE] = HilbS(u2, prec, inter);
disp(toc());
