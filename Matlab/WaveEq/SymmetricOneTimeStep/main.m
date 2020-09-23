%In this script we will solve numerically a kinematic match between 
%A perfect sphere and a constant-tension frictionless elastic band. 

clc;
%%

%First, lets define the constans of the problem

N = 100; %Number of poins in the spatial coordinate per unit length
L = 3; %Number of radii in half a length of the rope
Ntot = L * N; %Total Number of non-trivial points in the spatial coordinate}
delx = 1/N; %Spatial step
r = 0.5; %delt/delx
delt = delx * r; %Time Step
R = 1; %Radius of the sphere
T = 1; %Tension of the sope
g = 9.80665; %Gravity of earth in m/s^2
mu = 1; %Density of the material per unit length
m = 1; %Mass of the ball


timeStamps = 0; %Vector of time Stamps
fTime = 5; %Final time to be simulated
z_k = 2; %zk(1) is the current position of the center of the ball
v_k = zeros(1, 1); %derivative of zk at current time
P_k = []; %Vector of pressure. Only non-trivial points are saved. 
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
Eta_k_prob = zeros(Ntot, 5); %Vector of positions of the rope
%f = @(x) exp((-x.^2)/2) .* cos(2*pi*x);
%Eta_k = f(linspace(0, 1, Ntot))' - f(1);
%Eta_k = -[Eta_k; zeros(Ntot - size(Eta_k, 1), 1)];

%Now vectors of pressure. They may have different sizes, so we define 5 of
%them
Pk_1 = [];
Pk_2 = [];
Pk_3 = [];
Pk_4 = [];
Pk_5 = [];

u_k_prob = zeros(Ntot, 5); %d/dt Eta_k = u_k

c1 = -mu * R * g / T;
c2 = -mu * R / (2 * T * m); 

while (timeStamps < fTime)
    
    recalculate = false;
    %First, we solve with the same number of contact points that of the
    %last time.
    [Eta_k_prob(:,3), u_k_prob(:, 3), z_k_prob(3), ...
        v_k_prob(3), Pk_3, errortan(3)] = solveWithCP(cPoints, mCPoints, Eta_k, u_k, z_k, v_k, ...
        P_k, delt, delx, Ntot, R, c1 * delt, c2 * delx * delt, T);
    
    %If absolutely no error
    if errortan(3) < 1e-13 % We can change this to accept the solution if errortan is less than a (small) value.
        Eta_k = Eta_k_prob(:, 3);
        u_k = u_k_prob(:, 3);
        z_k = z_k_prob(3);
        v_k = v_k_prob(3);
        P_k = Pk_3;
        
    else % (If it is possible to have a different number of contact Points)
        %Lets try with one more contact point.
        [Eta_k_prob(:,4), u_k_prob(:, 4), z_k_prob(4), ...
            v_k_prob(4), Pk_4, errortan(4)] = solveWithCP(cPoints + 1, mCPoints, Eta_k, u_k, z_k, v_k, ...
            P_k, delt, delx, Ntot, R, c1 * delt, c2 * delx * delt, T);
        
        %Also, lets try with one contact point less.
        [Eta_k_prob(:,2), u_k_prob(:, 2), z_k_prob(2), ...
            v_k_prob(2), Pk_2, errortan(2)] = solveWithCP(cPoints - 1, mCPoints, Eta_k, u_k, z_k, v_k, ...
            P_k, delt, delx, Ntot, R, c1 * delt, c2 * delx * delt, T);
        
        if errortan(3) > errortan(4) || errortan(3) > errortan(2)
            if errortan(4) <= errortan(2)
                %Now lets check if errortan gets better
                [~, ~, ~, ~, ~, errortan(5)] = solveWithCP(cPoints + 2, mCPoints, Eta_k, u_k, z_k, v_k, ...
                P_k, delt, delx, Ntot, R, c1 * delt, c2 * delx * delt, T);

                if errortan(4) < errortan(5)
                    Eta_k = Eta_k_prob(:, 4);
                    u_k = u_k_prob(:, 4);
                    z_k = z_k_prob(4);
                    v_k = v_k_prob(4);
                    P_k = Pk_4;
                    cPoints = cPoints + 1;
                    clc;
                    disp(errortan(4));
                else
                    recalculate = true;
                end

            else
                %Now lets check if errortan gets better
                [~, ~, ~, ~, ~, errortan(1)] = solveWithCP(cPoints - 2, mCPoints, Eta_k, u_k, z_k, v_k, ...
                P_k, delt, delx, Ntot, R, c1 * delt, c2 * delx * delt, T);

                if errortan(2) < errortan(1)
                    Eta_k = Eta_k_prob(:, 2);
                    u_k = u_k_prob(:, 2);
                    z_k = z_k_prob(2);
                    v_k = v_k_prob(2);
                    P_k = Pk_2;
                    cPoints = cPoints - 1;
                    clc;
                    disp(errortan(2));
                else
                    recalculate = true;
                end

            end %End of (errortan(4) < errortan(2))
        else %the same number of contact points is the best solution
            Eta_k = Eta_k_prob(:, 3);
            u_k = u_k_prob(:, 3);
            z_k = z_k_prob(3);
            v_k = v_k_prob(3);
            P_k = Pk_3;
            clc;
            disp(errortan(3));
        end

    end
    if recalculate == false
        plotresults(Eta_k, z_k, circleX, circleY, timeStamps, L, delt);
        timeStamps = timeStamps + delt;
    else
        delt = delt/2;
    end

end

disp('Im out at time:');
disp(timeStamps(end));

function plotresults(Eta_k, z_k, circleX, circleY, timeStamps, L, delt)
    plot(circleX, circleY + z_k, 'Color', 'black', 'LineWidth', 2.5);
    hold on;
    plot(linspace(-L, L, 2 * size(Eta_k, 1) - 1), [Eta_k(end:-1:1); ...
       Eta_k(2:end)], 'LineWidth', 3);
    s1 = sprintf("t   =%.3f", timeStamps);
    s2 = sprintf("z_k =%.3f", z_k); 
    title({s1, s2}, 'Position', [-L+0.5 L-0.6 1]);
    axis([-L L -L/2 L]) 
    hold off;
    pause(delt * 2);
end