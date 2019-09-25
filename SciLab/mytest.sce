
signal = 1:10;
T = length(signal);
clear f_mirror;
f_mirror(1:T/2) = signal(T/2:-1:1);
f_mirror(T/2+1:3*T/2) = signal;
f_mirror(3*T/2+1:2*T) = signal(T:-1:T/2+1);
f = f_mirror;
f_hat = fftshift(fft(f));
f_hat_plus = f_hat;
f_hat_plus(1:T/2) = 0;
