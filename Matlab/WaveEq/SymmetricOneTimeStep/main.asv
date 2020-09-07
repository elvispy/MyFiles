%In this script we will solve numerically a kinematic match between 
%A perfect sphere and a constant-tension frictionless elastic band. 

clear;clc;
%%

%First, lets define the constans of the problem

N = 500; %Number of poins in the spatial coordinate per unit length
L = 4; %Number of radii in half a length of the rope
Ntot = L * N; %Total Number of non-trivial points in the spatial coordinate}
delx = 1/N; %Spatial step
r = 0.5; %delt/delx
delt = delx * r; %Time Step
R = 1; %Radius of the sphere
T = 1; %Tension of the sope
g = 9.80665; %Gravity of earth in m/s^2
mu = 1; %Density of the material per unit length
m = 1; %Mass of the ball


timeStamps = zeros(1, 1); %Vector of time Stamps
fTime = 5; %Final time to be simulated
z_k = 30; %zk(1) is the current position of the center of the ball
v_k = zeros(1, 1); %derivative of zk at current time
P_k = zeros(Ntot, 1); %Vector of pressure
Eta_k = zeros(Ntot, 1); %Vector of positions of the rope
u_k = zeros(Ntot, 1); %d/dt Eta_k = u_k

aux = linspace(0, 2*pi, 100);
circleX = R * cos(aux);
circleY =  R * sin(aux); %Circle with radius R to plot

%%
%Now its time to loop and solve the PDE

cPoints = 0; %Number of contact points
mCPoints = N * R; %Maximum number of contact points
errortan = zeros(1, 5); %Errors with the number of contact points

z_k_prob = zeros(1, 5); %zk(1) is the current position of the center of the ball
%zk(2) is the next position of the center of the ball
v_k_prob = zeros(1, 5); %derivative of zk at current time
P_k_prob = zeros(Ntot, 5); %Vector of pressure
Eta_k_prob = zeros(Ntot, 5); %Vector of positions of the rope
f = @(x) exp((-x.^2)/2);
Eta_k = f(linspace(0, 1, Ntot))' - f(1);
%Eta_k = [Eta_k; zeros(Ntot - size(Eta_k, 1), 1)];

u_k_prob = zeros(Ntot, 5); %d/dt Eta_k = u_k

c1 = -mu * R * g * delt / T;
while (timeStamps(end) < fTime)
   if cPoints == 0
       [Eta_k_prob(:,3), u_k_prob(:, 3), z_k_prob(3), ...
           v_k_prob(3), errortan(3)] = solve_0(Eta_k, u_k, z_k, v_k, delt,...
           delx, Ntot, c1, R);
       if errortan(3) > 0
          break 
       else
           disp(z_k);
           Eta_k = Eta_k_prob(:, 3);
           u_k = u_k_prob(:, 3);
           z_k = z_k_prob(3);
           v_k = v_k_prob(3);

           plot(circleX, circleY + z_k);
           hold on;
           plot(linspace(-L, L, 2 * size(Eta_k, 1) - 1), [Eta_k(end:-1:1); ...
               Eta_k(2:end)]);
           axis([-L L -3.5 8]) 
           hold off;
           pause(delt * 10);
           
           
       end
       timeStamps = [timeStamps timeStamps(end) + delt];
   end
end

disp('Im out at time:');
disp(timeStamps(end));