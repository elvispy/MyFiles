%%mainv_1.2

%% CONSTANTS' DEFINITIONS

parameters;
Fr = (mu*rS*g)/Tm; %Froude number
Mr = mu*(rS^2)/mS; %Ratio of masses

N = 50; %Number of dr intervals in the spatial (radial) dimension per unit length
Ntot = R_f * N; %Total number of non-trivial points in the spatial coordinate

dr = 1/N; % N intervals in one unit = every interval (dr) measures 1/N
dt = dr; %Just a random choice for dt (for now)
tFinal = 100; %Maximum dimensionless time to be simulated (rS/sqrt(Tm/mu) is the time dimension)
tInit = 0; %Initial time (dimensionless)

%% Initial Conditions

z_k_prob = zeros(1, 5); %Initial position of the center of the ball
v_k_prob = zeros(1, 5); %Initial velocity of the ball (previous and following times)
Eta_k_prob = zeros(Ntot, 5); %Position of the membrane at different times
u_k_prob = zeros(Ntot, 5); %Velocities of the membrane at different times
errortan = Inf * ones(1, 5);

z_k = 1.1; %Current position of the center of the ball (Dimensionless)
v_k = -.09; %Current velocity of the ball (dimensionless)
P_k = []; %Current vector of pressures. Only non trivial points saved (Empty vector == membrane and ball should not be touching)
u_k = zeros(Ntot, 1); %Initial vertical velocity of the membrane (a.k.a. d/dt Eta_k = u_k)
Eta_k = zeros(Ntot, 1); %Initial position of the membrane
%f = @(x) exp(-x.^2)';
%Eta_k = f(linspace(0, 30, Ntot))/2;

%Initial pressures (they are all trivial!)
Pk_1 = []; %Possible pressure with two less contact points
Pk_2 = []; %Pressure pressure with one less contact point
Pk_3 = []; %Possible pressure with the same number of contact points
Pk_4 = []; %Possible pressure with one more contact point
Pk_5 = []; %Possible pressure with two more contact points

%% Flow control Variables

cPoints = length(P_k); %Initial number of contact points
mCpoints = N + 1; %Maximum number of allowed contact points
t = tInit; % t is the variable that will keep track of the time
tMin = tInit * (1e-5); %Minimum time step allowed, dt >= tMin

%Now we save the sphere in an array (For plotting
aux = linspace(0, 2*pi, 50); 
circleX = cos(aux);
circleY = sin(aux);
width = N;
xplot = linspace(0, width/N, width);

%% Main Loop

while (t <= tFinal)
    %Reset some parameters
    Eta_k_prob = zeros(Ntot, 5);
    u_k_prob = zeros(Ntot, 5);
    z_k_prob = zeros(1, 5);
    v_k_prob = zeros(1, 5);
    errortan = Inf * ones(1, 5);
    Pk_1 = []; Pk_2 = []; Pk_3 = []; Pk_4 = []; Pk_5 = [];
    recalculate = false;
    
    if cPoints < .5 %if previously in flight
        % 1)Check if keep flying is the best option
        [Eta_k_prob(:, 3), u_k_prob(:, 3), z_k_prob(3), v_k_prob(3), errortan(3)] = ...
            freefall(Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot); Pk_3 = [];
        if errortan(3) < 1e-10
            z_k = z_k_prob(3);
            v_k = v_k_prob(3);
            u_k = u_k_prob(:, 3);
            Eta_k = Eta_k_prob(:, 3);
            P_k = [];
            cPoints = 0;
        else
            %We try with one and two points
            [Eta_k_prob(:, 4), u_k_prob(:, 4), z_k_prob(4), v_k_prob(4), ...
                Pk_4, errortan(4)] = solveNcorner(1, Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot);
            [~,~,~,~,~, errortan(5)] = solveNcorner(2, Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot);
            
            if abs(errortan(4)) < abs(errortan(5))
               %Accept solutions 
               z_k = z_k_prob(4);
               v_k = v_k_prob(4);
               u_k = u_k_prob(:, 4);
               Eta_k = Eta_k_prob(:, 4);
               P_k = Pk_4;
               cPoints = 1;
            else
                %%%%%%%%%%%%%%%%%%%%Smth to recalculate
                recalculate = true;
            end 
        end
        % 2)If not, check if one contact point is better than two contact
        % points
    elseif cPoints == 1 %Exactly one contact point in previous time
        % 1)Check if one point is better than two and zero contact points
        
        %First, zero
        [Eta_k_prob(:, 2), u_k_prob(:, 2), z_k_prob(2), v_k_prob(2), ...
                errortan(2)] = freefall(Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot);
            
        if abs(errortan(2)) < 0.5
           %Accept results
           z_k = z_k_prob(2);
           v_k = v_k_prob(2);
           u_k = u_k_prob(:, 2);
           Eta_k = Eta_k_prob(:, 2);
           P_k = Pk_2;
           cPoints = 0;
        else
            %If not, lets seek further ahead
            %Same number of contact points
            [Eta_k_prob(:, 3), u_k_prob(:, 3), z_k_prob(3), v_k_prob(3), ...
                Pk_3, errortan(3)] = solveNcorner(1, Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot);
            [Eta_k_prob(:, 4), u_k_prob(:, 4), z_k_prob(4), v_k_prob(4), ...
                Pk_4, errortan(4)] = solveNcorner(2, Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot);
            if abs(errortan(3)) < abs(errortan(4))
                %Accept results
                z_k = z_k_prob(3);
                v_k = v_k_prob(3);
                u_k = u_k_prob(:, 3);
                Eta_k = Eta_k_prob(:, 3);
                P_k = Pk_3;
                cPoints = 1;
            else
                %Lets check if two more points is good
                [~,~,~,~,~, errortan(5)] = solveNcorner(3, Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot);
                if abs(errortan(4)) < abs(errortan(5))
                    %Accept results
                    z_k = z_k_prob(4);
                    v_k = v_k_prob(4);
                    u_k = u_k_prob(:, 4);
                    Eta_k = Eta_k_prob(:, 4);
                    P_k = Pk_4;
                    cPoints = 2;
                else
                    %%%%%%%%%%%%%%%%%%%%Smth to recalculate
                    recalculate = true;
                end
                    
            end
        end
    elseif cPoints > 1.5 && cPoints < 2.5
        % 1)Check if two point is better than one and three contact points
        
        [~,~,~,~, errortan(1)] = freefall(Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot);
        if abs(errortan(1)) < 0.5
           %%%%%%%%%%% Smth to recalculate
           recalculate = true;
        else
            [Eta_k_prob(:, 3), u_k_prob(:, 3), z_k_prob(3), v_k_prob(3), ...
                Pk_3, errortan(3)] = solveNcorner(2, Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot);
            [Eta_k_prob(:, 2), u_k_prob(:, 2), z_k_prob(2), v_k_prob(2), ...
                Pk_2, errortan(2)] = solveNcorner(1, Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot);
            if abs(errortan(2)) < abs(errortan(3))
                %Accept results
                z_k = z_k_prob(2);
                v_k = v_k_prob(2);
                u_k = u_k_prob(:, 2);
                Eta_k = Eta_k_prob(:, 2);
                P_k = Pk_2;
                cPoints = 1;
            else
                [Eta_k_prob(:, 4), u_k_prob(:, 4), z_k_prob(4), v_k_prob(4), ...
                    Pk_4, errortan(4)] = solveNcorner(3, Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot);
                
                if abs(errortan(3)) < abs(errortan(4))
                    %Accept results
                    z_k = z_k_prob(3);
                    v_k = v_k_prob(3);
                    u_k = u_k_prob(:, 3);
                    Eta_k = Eta_k_prob(:, 3);
                    P_k = Pk_3;
                    cPoints = 2;
                else
                    [~,~,~,~,~, errortan(5)] = solveNcorner(4, Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot);
                    if abs(errortan(4)) < abs(errortan(5))
                        %Accept results
                        z_k = z_k_prob(4);
                        v_k = v_k_prob(4);
                        u_k = u_k_prob(:, 4);
                        Eta_k = Eta_k_prob(:, 4);
                        P_k = Pk_4;
                        cPoints = 3;
                    else
                       %%%%%%%%%% Smth to recalculate 
                       recalculate = true;
                    end
                end
                
            end
        end
    elseif cPoints > 2.5 && cPoints < mCpoints - 1.5
        [Eta_k_prob(:, 3), u_k_prob(:, 3), z_k_prob(3), v_k_prob(3), ...
            Pk_3, errortan(3)] = solveNcorner(cPoints, Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot);
        [Eta_k_prob(:, 2), u_k_prob(:, 2), z_k_prob(2), v_k_prob(2), ...
            Pk_2, errortan(2)] = solveNcorner(cPoints - 1, Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot);
        if abs(errortan(2)) < abs(errortan(3))
            [~,~,~,~,~, errortan(1)] = solveNcorner(cPoints - 2, Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot);
            if abs(errortan(2)) < abs(errortan(1))
                z_k = z_k_prob(2);
                v_k = v_k_prob(2);
                u_k = u_k_prob(:, 2);
                Eta_k = Eta_k_prob(:, 2);
                P_k = Pk_2;
                cPoints = cPoints - 1;
            else
                %%%%%%%%%% Smth to recalculate
                recalculate = true;
            end
        else
            [Eta_k_prob(:, 4), u_k_prob(:, 4), z_k_prob(4), v_k_prob(4), ...
                Pk_4, errortan(4)] = solveNcorner(cPoints + 1, Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot);
            if abs(errortan(3)) < abs(errortan(4))
                z_k = z_k_prob(3);
                v_k = v_k_prob(3);
                u_k = u_k_prob(:, 3);
                Eta_k = Eta_k_prob(:, 3);
                P_k = Pk_3;
            else
                [~,~,~,~,~, errortan(5)] = solveNcorner(cPoints + 2, Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot);
                
                if abs(errortan(4)) < abs(errortan(5))
                    z_k = z_k_prob(4);
                    v_k = v_k_prob(4);
                    u_k = u_k_prob(:, 4);
                    Eta_k = Eta_k_prob(:, 4);
                    P_k = Pk_4;
                    cPoints = cPoints + 1;
                else
                    %%%%%%%%%% smth to recalculate
                    recalculate = true;
                end
            end    
        end
    elseif cPoints > mCpoints - 1.5 && cPoints < mCpoints -0.5
        [Eta_k_prob(:, 3), u_k_prob(:, 3), z_k_prob(3), v_k_prob(3), ...
            Pk_3, errortan(3)] = solveNcorner(cPoints, Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot);
        [Eta_k_prob(:, 2), u_k_prob(:, 2), z_k_prob(2), v_k_prob(2), ...
            Pk_2, errortan(2)] = solveNcorner(cPoints - 1,Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot);
        if abs(errortan(2)) < abs(errortan(3))
            [~,~,~,~,~, errortan(1)] = solveNcorner(cPoints - 2, Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot);
            if abs(errortan(2)) < abs(errortan(1))
                z_k = z_k_prob(2);
                v_k = v_k_prob(2);
                u_k = u_k_prob(:, 2);
                Eta_k = Eta_k_prob(:, 2);
                P_k = Pk_2;
                cPoints = cPoints - 1;
            else
                %%%%%%%% smth to recalculate
                recalcualte = true;
            end
        else
            [Eta_k_prob(:, 4), u_k_prob(:, 4), z_k_prob(4), v_k_prob(4), ...
                Pk_4, errortan(4)] = solveNcorner(cPoints + 1, Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot);
            if abs(errortan(3)) < abs(errortan(4))
                z_k = z_k_prob(3);
                v_k = v_k_prob(3);
                u_k = u_k_prob(:, 3);
                Eta_k = Eta_k_prob(:, 3);
                P_k = Pk_3;
            else
                % Since we cannot evaluate two more points, we just accept
                z_k = z_k_prob(4);
                v_k = v_k_prob(4);
                u_k = u_k_prob(:, 4);
                Eta_k = Eta_k_prob(:, 4);
                P_k = Pk_4;
                cPoints = cPoints + 1;
            end
        end

    else % Max number of contact points
        [Eta_k_prob(:, 3), u_k_prob(:, 3), z_k_prob(3), v_k_prob(3), ...
            Pk_3, errortan(3)] = solveNcorner(cPoints, Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot);
        [Eta_k_prob(:, 2), u_k_prob(:, 2), z_k_prob(2), v_k_prob(2), ...
            Pk_2, errortan(2)] = solveNcorner(cPoints - 1, Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot);
        if abs(errortn(2)) < abs(errortan(3))
            [~,~,~,~,~, errortan(1)] = solveNcorner(cPoints - 2, Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot);
            if abs(errortan(2)) < abs(errortan(1))
                z_k = z_k_prob(2);
                v_k = v_k_prob(2);
                u_k = u_k_prob(:, 2);
                Eta_k = Eta_k_prob(:, 2);
                P_k = Pk_2;
                cPoints = cPoints - 1;
            else
                %%%%% smth to recalculate
                recalcualte = true;
            end
        else
            z_k = z_k_prob(3);
            v_k = v_k_prob(3);
            u_k = u_k_prob(:, 3);
            Eta_k = Eta_k_prob(:, 3);
            P_k = Pk_3;
        end
    end
    
    if dt < 1e-40
        disp("No");
    end
    
    if recalculate == true
        dt = dt/2;
    else 
        %add time
        t = t + dt;


        %Plot results
        cla;
        etaplot=[flipud(Eta_k(2:Ntot));Eta_k];
        %plot(circleX,z_k+circleY,'k','Linewidth',1.5);
        rectangle('Position', [-1, z_k-1, 2, 2], ...
            'Curvature', 1, 'Linewidth', 2);
        hold on

        plot([-fliplr(xplot(2:end)),xplot],[flipud(Eta_k(2:width));Eta_k(1:width)]','LineWidth',2);
        %quiver([-fliplr(xplot(2:end)), xplot], [flipud(Eta_k(2:width));Eta_k(1:width)]', zeros(1,2*width-1), [flipud(u_k(2:width));u_k(1:width)]');
        %quiver([-fliplr(xplot(2:cPoints)), xplot(1:cPoints)], [flipud(Eta_k(2:cPoints));Eta_k(1:cPoints)]', zeros(1,2*cPoints-1), [flipud(u_k(2:cPoints));u_k(1:cPoints)]');
        %hold off
        xlim([-width/N, width/N]); ylim([-1, 1]);
        axis equal;
        title(['   t = ',sprintf('%0.2f', t),'   ','nl = ', ...
            sprintf('%.0f', cPoints),' vz = ', sprintf('%0.2f', v_k)],'FontSize',16);
        drawnow;
        
        disp(P_k');
        pause;
        
    end
    
end
