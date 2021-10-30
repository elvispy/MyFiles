%In this script we will solve numerically a kinematic match between
%A perfect sphere and a constant-tension frictionless elastic band.
clear variables;

%% CONSTANTS' DEFINITIONS

% Loading Physical constants from .m file
parameters;
Fr = (mu*rS*g)/Tm; %Froude number
Mr = mu*(rS^2)/mS; %Ratio of masses

%Numerical constants
N = 10; %Number of dx intervals in the spatial (radial) coordinate per unit length
Ntot = R_f * N; %Total number of non-trivial points in the spatial coordinate
dr = 1/N; %Spatial step

dt = 0.02/Tunit; %Time step (dimensionless)
tFinal = 15/Tunit; %Maximum time (dimensionless) to be simulated.
tInit = 0/Tunit; %Initial time (dimensionless)
rt = 0.25/Tunit; %Interval of time to be recorded in the matrix. (1/0.25 = 4 frames per ms)
ii = 1; %for saving matrix
mii = ceil((tFinal-tInit)/rt) + 1; %maximum value of ii 

%% Initial Conditions

z_k_prob = zeros(1, 5); %Initial position of the center of the ball
v_k_prob = zeros(1, 5); %Initial velocity of the ball (previous and following times)
Eta_k_prob = zeros(Ntot, 5); %Position of the membrane at different times
u_k_prob = zeros(Ntot, 5); %Velocities of the membrane at different times
errortan = Inf * ones(1, 5);

recordedz_k = zeros(mii, 1);
recordedEta = zeros(mii, Ntot);

z_k = 3/Lunit; %Current position of the center of the ball (dimensionless)
H0 = 28; %Initial height (mm). 
v_k = -sqrt(2*g*(H0-z_k*Lunit))/Vunit; % Velocity of the center of the ball (dimensionless)
P_k = []; %Vector of pressure. Only non-trivial points are saved
u_k = zeros(Ntot, 1); %Initial vertical velocity of the membrane (a.k.a. d/dt Eta_k = u_k)
Eta_k = zeros(Ntot, 1); %Initial position of the membrane
%f = @(x) exp(-x.^2)';
%Eta_k = f(linspace(0, 30, Ntot))/2;

%Initial pressures 
Pk_1 = []; %Possible pressure with two less contact points
Pk_2 = []; %Pressure pressure with one less contact point
Pk_3 = []; %Possible pressure with the same number of contact points
Pk_4 = []; %Possible pressure with one more contact point
Pk_5 = []; %Possible pressure with two more contact points

%% Flow control Variables

cPoints = length(P_k); %Initial number of contact points
ctime = 0; %To record contact time
maxDef = 0; %to record max deflection;
ch = true; %Boolean to record maximum deflection time
cVar = false; %To record first contact time
mCPoints = N + 1; %Maximum number of allowed contact points
t = tInit; % t is the variable that will keep track of the time
tMin = tInit * (1e-5); %Minimum time step allowed, dt >= tMin
tMax = dt;

%Now we save the sphere in an array (For plotting
aux = linspace(0, 2*pi, 50); 
circleX = cos(aux);
circleY = sin(aux);
width = 3 * N;
xplot = linspace(0, width/N, width);

%% Main Loop

while (ii <= mii)

    %Reset some parameters
    Eta_k_prob = zeros(Ntot, 5);
    u_k_prob = zeros(Ntot, 5);
    z_k_prob = zeros(1, 5);
    v_k_prob = zeros(1, 5);
    errortan = Inf * ones(1, 5);
    Pk_1 = []; Pk_2 = []; Pk_3 = []; Pk_4 = []; Pk_5 = [];
    recalculate = false;
    
    %First, we try to solve with the same number of contact points
    [Eta_k_prob(:,3), u_k_prob(:, 3), z_k_prob(3), ...
        v_k_prob(3), Pk_3, errortan(3)] = getNextStep(cPoints, mCPoints, ...
        Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot);
    
    if errortan(3) < 1e-8 %If almost no error, we accept the solution
        Eta_k = Eta_k_prob(:, 3);
        u_k = u_k_prob(:, 3);
        z_k = z_k_prob(3);
        v_k = v_k_prob(3);
        P_k = Pk_3;
        
    else % If there is some error, we try with diffferent contact points
        
        %Lets try with one more point
        [Eta_k_prob(:,4), u_k_prob(:, 4), z_k_prob(4), ...
            v_k_prob(4), Pk_4, errortan(4)] = getNextStep(cPoints + 1, mCPoints, ...
            Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot);
        
        %Lets try with one point less
        [Eta_k_prob(:,2), u_k_prob(:, 2), z_k_prob(2), ...
            v_k_prob(2), Pk_2, errortan(2)] = getNextStep(cPoints - 1, mCPoints, ...
            Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot);
        
        if errortan(3) > errortan(4) || errortan(3) > errortan(2)
            if errortan(4) <= errortan(2)
                %Now lets check with one more point to be sure
                [~, ~, ~, ~, ~, errortan(5)] = getNextStep(cPoints + 2, mCPoints, ...
            Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot);
                
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
                [~, ~, ~, ~, ~, errortan(1)] = getNextStep(cPoints-2, mCPoints, ...
            Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot);
                
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
            if (isinf(errortan(3)))
                recalculate = true;
            else                        
                Eta_k = Eta_k_prob(:, 3);
                u_k = u_k_prob(:, 3);
                z_k = z_k_prob(3);
                v_k = v_k_prob(3);
                P_k = Pk_3;
            end
        end %
    end

    
    if recalculate  == false %timestep is ok
        plotresults(Eta_k, u_k, z_k, v_k, cPoints, t, ...
            N, xplot, circleX, circleY, width, Tunit, Vunit);
        
        
        t = t + dt;
%         %We will adapt timestep 
%         if dt < tMax
%             dt = 2*dt;
%         end
        
    else
        disp("entre");
        dt = dt/2;        
    end
end % end while


%% Local Functions

function plotresults(Eta_k, u_k, z_k, v_k, cPoints, t, N, xplot, ...
    circleX, circleY, width, Tunit, Vunit)

    cla;
    plot(circleX,z_k+circleY,'k','Linewidth',1.5);
    %rectangle('Position', [-1, z_k-1, 2, 2], ...
    %    'Curvature', 1, 'Linewidth', 2);
    hold on;

    plot([-fliplr(xplot(2:end)),xplot],[flipud(Eta_k(2:width));Eta_k(1:width)]','LineWidth',2);
    quiver([-fliplr(xplot(2:end)), xplot], [flipud(Eta_k(2:width));Eta_k(1:width)]',...
        zeros(1,2*width-1), [flipud(u_k(2:width));u_k(1:width)]');
    
    xlim([-width/N, width/N]);
    %xlim([-1, 1])
    ylim([z_k-2, z_k+2]);
    axis equal;
    title(['   t = ',sprintf('%0.2f (ms)', t*Tunit),'   ','nl = ', ...
        sprintf('%.0f', cPoints),' vz = ', sprintf('%0.10f', v_k*Vunit)],'FontSize',16);
    drawnow;
%     Fac = 4;
%     span = Fac * Lunit; %Interval to be plotted
%     %dimPosition = z_k * Lunit;
%     dimTime = timeStamp * Tunit;
% 
%     %plot(circleX, circleY + dimPosition, 'Color', 'black', 'LineWidth', 2.5);
%     cla;
%     rectangle('Position', [-Lunit, z_k*Lunit-Lunit, 2*Lunit, 2*Lunit], ...
%         'Curvature', 1, 'Linewidth', 1.5);
%     hold on;
%     plot(linspace(-span, span, 2 * N * Fac - 1), ...
%         [Eta_k(N*Fac:-1:2);Eta_k(1:N*Fac)]);
%     s1 = sprintf("t  =%.2f ms", dimTime);
%     s2 = sprintf("z_k =%.2f mm", z_k * Lunit); 
%     
%     title([s1, s2])%, 'Position', [-span+5 span-6]);
%     %axis([-span span -span/2 span]);
%     axis equal;
%     hold off;
%     grid on
%     pause(delt * Tunit / 1000);
end