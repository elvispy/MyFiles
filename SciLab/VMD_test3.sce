// test-script for VMD
//--------------- Preparation
clear all;
//close all;
clc;

// Time Domain 0 to T
T = 3500;
fs = 1/T;
t = (1:T)/T;
freqs = 2*%pi*(t-0.5-1/T)/(fs);

// center frequencies of components
f_1 = 2;
f_2 = 24;
f_3 = 288;

// modes
v_1 = (cos(2*%pi*f_1*t));
v_2 = 1/4*(cos(2*%pi*f_2*t));
v_3 = 1/16*(cos(2*%pi*f_3*t));

// for visualization purposesu


// composite signal, including noise
f = v_1 + v_2 + v_3 + 0.1*rand(1, 'normal');
f_hat = fftshift((fft(f)));

// some sample parameters for VMD
alpha = 2000;        // moderate bandwidth constraint
tau = 0;            // noise-tolerance (no strict fidelity enforcement)
K = 3;              // 3 modes
DC = 0;             // no DC part imposed 
init = 1;           // initialize omegas uniformly
tol = 1e-10;        //Tolerance of the method in VMD
N = 1200;            //Number of iterations before getting out
//inter = 1.D-3;
inter = 4 * %pi;    //Interval of definition of the data
prec = 1e-5;        //precision in the Hilbert Marginal Spectrum decomposition




//--------------- Run actual VMD code
disp("Summary")
disp("-------------")
tic();
[u, u_hat, omega] = VMD3(f, alpha, tau, K, DC, init, tol, N, inter);

disp("Running time  of  finding of IMFs")
disp(toc());
disp("-------------")
tic();
[u2, u_hat2, omega2] = VMD2(f, alpha, tau, K, DC, init, tol, N, inter);
disp(toc())
/*
[HMS, HMSEE] = hilbertVMD(u, inter, prec);

disp("Running time of HMS calculations")
disp(toc());
disp("-----1-----")





approx = zeros(1, length(u(1, :)));

for i = 1:K
    approx = approx + u(i, :)
    //approx2 = approx2 + u2(i, :)
end
//plot(HMS) beware of the precision. Could overload Scilab if too small.
disp("Error (L2 norm) between sum of the u_ks (the IMFS) and the original signal")
disp(norm(f-approx, 2))
disp("----")
//disp(norm(f-approx2, 2))
//Testing different tolerance and N levels


*/



/*
//saving the data 

b = pwd();
b = b + "\IMFData"
if ~isdir(b) then
    mkdir("IMFData");
end

chdir(b);
    
filename = fullfile(b, "IMF.csv");
csvWrite(u, filename);


//filename = fullfile(b, "IMF_hat.csv");
//csvWrite(u_hat, filename);
*/

