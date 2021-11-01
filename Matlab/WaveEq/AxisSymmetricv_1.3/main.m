%%mainv_1.3
%Tries to solve the kinematic match with Implicit Euler and getNextStep

%% CONSTANTS' DEFINITIONS

clearvars;

parameters;
Fr = (mu*rS*g)/Tm; %Froude number
Mr = mu*(rS^2)/mS; %Ratio of masses

%Numerical constants
N = 15; %Number of dx intervals in the spatial (radial) coordinate per unit length
Ntot = ceil(R_f * N); %Total number of non-trivial points in the spatial coordinate
dr = 1/N; %Spatial step

dt = 0.04/Tunit; %Time step (dimensionless)
tFinal = 20/Tunit; %Maximum time (dimensionless) to be simulated.
tInit = 0/Tunit; %Initial time (dimensionless)
rt = max(0.1/Tunit, dt); %Interval of time to be recorded in the matrix. (1/0.25 = 4 frames per ms)
ii = 1; %for saving matrix
mii = ceil((tFinal-tInit)/rt) + 2; %maximum value of ii 

%% Initial Conditions

z_k_prob = zeros(1, 5); %Initial position of the center of the ball
v_k_prob = zeros(1, 5); %Initial velocity of the ball (previous and following times)
Eta_k_prob = zeros(Ntot, 5); %Position of the membrane at different times
u_k_prob = zeros(Ntot, 5); %Velocities of the membrane at different times
errortan = Inf * ones(1, 5);

recordedz_k = zeros(mii, 1);
recordedEta = zeros(mii, Ntot);

z_k = 2.5/Lunit; %Current position of the center of the ball (Dimensionless)
%------------------------------
H0 = 28; %Initial height of the center of the ball to calculate initial velocity (mm)
v_k = -sqrt(2*g*(H0-z_k*Lunit))/Vunit; %Current velocity of the ball (dimensionless)
%------------------------------
P_k = []; %Current vector of pressures. Only non trivial points saved (Empty vector == membrane and ball should not be touching)
u_k = zeros(Ntot, 1); %Initial vertical velocity of the membrane (a.k.a. d/dt Eta_k = u_k)
Eta_k = zeros(Ntot, 1); %Initial position of the membrane
%f = @(x) exp(-x.^2)';
%Eta_k = f(linspace(0, 30, Ntot))/2;

%%%Initial pressures (they are all trivial!)
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

%Now we save the sphere in an array (For plotting
aux = linspace(0, 2*pi, 50); 
circleX = cos(aux);
circleY = sin(aux);
width = 3 * N;
xplot = linspace(0, width/N, width);

%% For post processing

plotter = true;
%vars = [str2double(datestr(now, 'yyyymmddhhMMss')), 0, 0, round(v_k*Vunit, 3), Tm, rS];


%% Main Loop

while (ii <= mii)
    %Reset some parameters
    Eta_k_prob = zeros(Ntot, 5);
    u_k_prob = zeros(Ntot, 5);
    z_k_prob = zeros(1, 5);
    v_k_prob = zeros(1, 5);
    errortan = Inf * ones(1, 5);
    Pk_1 = []; Pk_2 = []; Pk_4 = []; Pk_5 = [];
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
        
        if (errortan(3) > errortan(4) || errortan(3) > errortan(2))
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
            if errortan(3) == Inf % ALl errors are infinity
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
        
    if recalculate == true
        dt = dt/2;
    else
        %%%%%%%%%%%%
        %%%%%%%%%%%%
        %SAVE THE RESULTS INTO A MATRIX
        if mod(t, rt) < dt
            recordedz_k(ii) = z_k;
            recordedEta(ii, :) = Eta_k;
            ii = ii+1;
        end
        %%%%%%%%%%%%
        %%%%%%%%%%%%
        %add time
        t = t + dt;
        
        %%%%%%%%%%%%
        %%%%%%%%%%%%
        if plotter == true
            %PLOT RESULTS
            cla;
            %plot(circleX*Lunit,(z_k+circleY)*Lunit,'k','Linewidth',1.5);
            rectangle('Position', [-Lunit, (z_k-1)*Lunit, 2*Lunit, 2*Lunit], ...
                'Curvature', 1, 'Linewidth', 2);
            hold on

            plot([-fliplr(xplot(2:end)),xplot] * Lunit,[flipud(Eta_k(2:width));Eta_k(1:width)]' * Lunit,'LineWidth',2);
            quiver([-fliplr(xplot(2:end)), xplot] * Lunit, [flipud(Eta_k(2:width));Eta_k(1:width)]' * Lunit,...
                zeros(1,2*width-1), [flipud(u_k(2:width));u_k(1:width)]' * Vunit);
            xlim([-width*Lunit/N, width*Lunit/N]);
            %xlim([-1, 1])
            ylim([(z_k-2)*Lunit, (z_k+2)*Lunit]);
            axis equal;
            title(['   t = ',sprintf('%0.2f (ms)', t*Tunit),'   ','nl = ', ...
                sprintf('%.0f', cPoints),' vz = ', sprintf('%0.5f (mm/ms)', v_k*Vunit)],'FontSize',16);
            drawnow;
        else
            clc;
            disp(['   t = ',sprintf('%0.2f (ms)', t*Tunit),'   ','nl = ', ...
                sprintf('%.0f', cPoints),' vz = ', sprintf('%0.5f (mm/ms)', v_k*Vunit)]);
            
        end
        
        %%%%%%%%%%%%
        %%%%%%%%%%%%
        % ANALISE CONTACT TIME AND MAXIMUM DEFLECTION
        
        if (cVar == false && cPoints > 0)
            cVar = true;
            maxDef = z_k;
        elseif (cVar == true && cPoints > 0)
            ctime = ctime + dt;
        elseif (cVar == true && cPoints == 0)
            break; % end simulation if contact ended.
        end
        if (cVar == true && v_k > 0)
            if (ch == true) %If velocity has changed sign, record maximum 
                %deflection only once

                maxDef = maxDef - z_k;
                ch = false;
            end
        end
    end     
end % END WHILE

%%%%%%%%%%%%
%POST PROCESSING
%%%%%%%%%%%%
% 
% if plotter == true
%     close;
% end
% 
% 
% vars(2) = round(ctime * Tunit, 4);
% vars(3) = round( maxDef * Lunit, 4);
% writematrix(vars, 'historial.csv', 'WriteMode', 'append');
% save('simulation.mat', 'recordedEta', 'recordedz_k');
% fprintf('Contact time: %0.2f (ms)\n', vars(2));
% fprintf('Maximum deflection: %0.2f (mm)\n', vars(3));
% disp('-----------------------------');
%     