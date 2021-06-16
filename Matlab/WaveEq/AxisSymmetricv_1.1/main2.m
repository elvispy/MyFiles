%In this script we will solve numerically a kinematic match between
%A perfect sphere and a constant-tension frictionless elastic band.
clear variables;

%% CONSTANTS' DEFINITIONS

% Loading Physical constants from .m file
parameters2;
Fr = (mu*R_s*g)/Tm; %Froude number
Mr = mu*(R_s^2)/mS; %Ratio of masses

%Units
Lunit = R_s; %Spatial unit of mesurement (in mm)
Vunit = sqrt(Tm/mu); %Velocity in mm/ms
Tunit = Lunit/Vunit; %Temporal unit of measurement (in ms)
Punit = mu * Lunit / Tunit^2; %Unit of pressure (in mg/ms^2)

%Numerical constants
N = 30; %Number of dx intervals in the spatial (radial) coordinate per unit length
Ntot = R_f * N; %Total number of non-trivial points in the spatial coordinate
delr = 1/N; %Spatial step
r = 0.5; % %delt/delx
delt = delr * r; %Time step
deltMax = delt; %Maximum number for the value of delt

%% Initial Conditions

z_k_prob = zeros(1, 5); %zk(1) is the current position of the center of the ball
v_k_prob = zeros(1, 5); %derivative of zk at current time
Eta_k_prob = zeros(Ntot, 5); %Vector of positions of the rope


z_k = 5.1/Lunit; %Current position of the center of the ball (dimensionless)
v_k = -.1/Vunit; % Velocity of the center of the ball (dimensionless)
P_k = []; %Vector of pressure. Only non-trivial points are saved
%Eta_k = zeros(Ntot, 1); %Vector of positions of the rope
f = @(x) exp(-x.^2);
Eta_k = f(delr*(0:(Ntot-1)))';


u_k = zeros(Ntot, 1); %d/dt Eta_k = u_k

%Initial pressures (they are all trivial!)
Pk_1 = [];
Pk_2 = [];
Pk_3 = [];
Pk_4 = [];
Pk_5 = [];

%% Variables' Declaration

fTime = 70; %Final time to be simulated (in ms)
fTime = floor(fTime/Tunit); %Final time to simulate (dimensionless)
midx = ceil(fTime/deltMax); %Maximum index tos save matrix


cPoints = 0; %Initial number of contact points
mCPoints = N+1; %Maximum number of contact points

currentTime = deltMax;
timeStamp = 0;

%Now we save the sphere in an array
aux = linspace(0, 2*pi, 50); 
circleX = R_s * cos(aux);
circleY = R_s * sin(aux);

%% Main Loop

curridx = 1; %Initial index to store data

while (curridx <= midx)
%while (false)   
    recalculate = false;
    errortan = Inf * ones(1, 5);
    
    %First, we try to solve with the same number of contact points
    [Eta_k_prob(:,3), u_k_prob(:, 3), z_k_prob(3), ...
        v_k_prob(3), Pk_3, errortan(3)] = getNextStep2(cPoints, mCPoints, ...
        Eta_k, u_k, z_k, v_k, P_k, delt, delr, Ntot, Fr, Mr);
    
    if errortan(3) < 1e-10 %If almost no error, we accept the solution
        Eta_k = Eta_k_prob(:, 3);
        u_k = u_k_prob(:, 3);
        z_k = z_k_prob(3);
        v_k = v_k_prob(3);
        P_k = Pk_3;
        
    else % If there is some error, we try with diffferent contact points
        
        %Lets try with one more point
        [Eta_k_prob(:,4), u_k_prob(:, 4), z_k_prob(4), ...
            v_k_prob(4), Pk_4, errortan(4)] = getNextStep2(cPoints + 1, mCPoints, ...
            Eta_k, u_k, z_k, v_k, P_k, delt, delr, Ntot, Fr, Mr);
        
        %Lets try with one point less
        [Eta_k_prob(:,2), u_k_prob(:, 2), z_k_prob(2), ...
            v_k_prob(2), Pk_2, errortan(2)] = getNextStep2(cPoints - 1, mCPoints, ...
            Eta_k, u_k, z_k, v_k, P_k, delt, delr, Ntot, Fr, Mr);
        
        if errortan(3) > errortan(4) || errortan(3) > errortan(2)
            if errortan(4) <= errortan(2)
                %Now lets check with one more point to be sure
                [~, ~, ~, ~, ~, errortan(5)] = getNextStep2(cPoints + 2, mCPoints, ...
            Eta_k, u_k, z_k, v_k, P_k, delt, delr, Ntot, Fr, Mr);
                
                if errortan(4) < errortan(5)
                    %Accept new data
                    Eta_k = Eta_k_prob(:, 4);
                    u_k = u_k_prob(:, 4);
                    z_k = z_k_prob(4);
                    v_k = v_k_prob(4);
                    P_k = Pk_4;
                    cPoints = cPoints + 1;
                else
                    %time step too big
                    recalculate = true;
                end
            else
                %now lets check if errortan is good enough with one point
                %less
                [~, ~, ~, ~, ~, errortan(1)] = getNextStep2(cPoints -2, mCPoints, ...
            Eta_k, u_k, z_k, v_k, P_k, delt, delr, Ntot, Fr, Mr);
                
                if errortan(2) < errortan(1)
                    Eta_k = Eta_k_prob(:, 2);
                    u_k = u_k_prob(:, 2);
                    z_k = z_k_prob(2);
                    v_k = v_k_prob(2);
                    P_k = Pk_2;
                    cPoints = cPoints - 1;
                    
                else
                    recalculate = true;
                end
                
            end %End of (errortan(4) < errortan(2))
            
        else %the same number of contact points is best    
            
            Eta_k = Eta_k_prob(:, 3);
            u_k = u_k_prob(:, 3);
            z_k = z_k_prob(3);
            v_k = v_k_prob(3);
            P_k = Pk_3;
            
        end %
    end
    
    
    if recalculate  == false %timestep is ok
        plotresults(Eta_k, z_k, circleX, circleY, timeStamp, ...
            Lunit, Tunit, N, delt);
        
        %We will adapt timestep in the future
        curridx = curridx + 1;
        timeStamp = timeStamp + delt;
        clc;
        disp(cPoints);
        
    else
        pause(Inf);
        delt = delt/2;        
    end
end % end while


%% Local Functions

function plotresults(Eta_k, z_k, circleX, circleY, timeStamp, ...
    Lunit, Tunit, N, delt)
    Fac = 10;
    span = Fac * Lunit; %Interval to be plotted
    dimPosition = z_k * Lunit;
    dimTime = timeStamp * Tunit;

    plot(circleX, circleY + dimPosition, 'Color', 'black', 'LineWidth', 2.5);
    hold on;
    plot(linspace(-span, span, 2 * N * Fac - 1), ...
        [Eta_k(N*Fac:-1:2);Eta_k(1:N*Fac)]);
    s1 = sprintf("t  =%.2f ms", dimTime);
    s2 = sprintf("z_k =%.2f mm", dimPosition); 
    
    title([s1, s2])%, 'Position', [-span+5 span-6]);
    axis([-span span -span/2 span]);
    hold off;
    grid on
    pause(delt * Tunit / 1000);
end