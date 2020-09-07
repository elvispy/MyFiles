%In this script we will solve numerically a kinematic match between 
%A perfect sphere and a constant-tension frictionless elastic band. 

clear;
clc;
tic();

%Lets define some variables (we dont know if we will use all of them):

N = 50; %Number of points in the spatial coordinate per unit length
L = 5; %Number of radii in half a length of the rope.
Ntot = L * N; %Total number of non-trivial points in the spatial coord
delx = L/N; %Time step
r = 0.5; %r = delt/delx
delt = delx * r; %Time step
R = 1; %Radius of the sphere
T = 1; %Tension of the rope.
g = 9.80665; %Gravity of earth in m/s^2
mu = 1; %Density of the material per unit length
m = 1; %Mass of the ball

u = zeros(L*N, 4*ceil(Ntot/r)); %this is the function u(x, t) which satisfies
%u_tt = u_xx - R*P(x, t)/T

time_interval = size(u);
time_interval = time_interval(2); %Units of time which will be simulated

I_r = diag(ones(Ntot, 1) * 4/(r*r)); %Identity matrix
M = 50 * (time_interval/ceil(Ntot/r)); %Number of graphs to show in the plotting,
%50 per unit time

%K matrix of the system:
K = sparse(diag(ones(Ntot, 1) * 2) - diag(ones(Ntot-1, 1), 1) - ... 
    diag(ones(Ntot-1, 1), -1));
K(1, 2) = -2;

%Now we will set initial conditions (temporarily)
sup = 0.1;
P = zeros(Ntot, time_interval);

for x = 1:floor(sup * Ntot)
    for t = 1:Ntot
        aux1 = (x-1) * (pi/(2*(Ntot*sup - 1)));
        aux2 = (t - Ntot/2)*pi/(2*Ntot); 
        P(x, t) = cos(aux1) * cos(aux2) / 25;
    end
end


%for j = 1:floor(Ntot * sup)
%    for k = 1:2
%        u(j, k) = cos((j-1) * (pi/(2*Ntot*sup))) ^ 2;
%    end
%end


%Now lets calculate u(x, t)
C = R * delx * delx / T;
for n = 2:time_interval-1
    u(:, n+1) = (I_r + K)\(2 * (I_r - K) * u(:, n) - (I_r + K) * u(:, n-1) ...
        - C * (P(:, n+1) + 2 * P(:, n) + P(:, n-1)));
end


%Now comes the ploggint part
hold off;
for i = 1:M
    aux = [u(Ntot:-1:2, floor(time_interval/M) * (i-1) + 1); ...
         u(:, floor(time_interval/M) * (i-1) + 1)];
    plot(linspace(-L, L, 2*Ntot - 1), aux);
    axis([-L L -1.5 1.5]);
    pause(0.05);
end

disp("Elapsed time");
disp(toc());
disp("-----------");