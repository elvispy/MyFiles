
function mainFunction(rS, R_f, Tm, mu, mS, g, options)
    %mainv_1.4
    %Tries to solve the kinematic match with getNextStep

    %% Handling default values
    arguments
        % All values have dimensions.
        
        %Radius of the sphere (in mm)
        rS (1, 1) {mustBePositive} = 1
        %Number of raddi in half a length of the membrane (dimensionless)
        R_f (1, 1) {mustBePositive} = 52.4/rS
        %Tension of the material (in mg / ms^2)
        Tm (1, 1) {mustBePositive} = 69
        %Density of membrane per unit of area (mg/mm^2) (Sara Wrap membrane)
        mu (1, 1) {mustBePositive} = 1.68e-2 
        %Mass of the ball (in mg) (7.8 is the ball's density in mg/mm3)
        mS (1, 1) {mustBePositive} = 7.8 * 4 * pi * (rS.^3) / 3;
        %Gravity of earth (in mm/ms^2)
        g (1, 1) {mustBePositive} = 9.80665e-3;
        
        options.z_k (1, 1) {mustBeReal} = -1 % in mm
        options.v_k (1, 1) {mustBeReal} = -0.1 % in mm/ms
        %options.Eta_k (1, :) {mustBeNumeric}
        %options.u_k (1, :) {mustBeNumeric}
        options.P_k (1, :) {mustBeNumeric} = []
        
        options.SimulTime (1, 1) {mustBePositive} = 50 % in ms
        options.RecordedTime = 0.04 % in ms
        options.FileName (1, 1) string  = "historial.csv"
        options.plotter (1, 1) logical = true
        options.method (1, 1) string {mustBeMember(options.method, ["Euler", "Trapecio"])} = "Euler"
    end
    if options.method == "Euler"
        options.method = @Euler;
    elseif options.method == "Trapecio"
        options.method = @trapecio2;
    end

    
    %% CONSTANTS' DEFINITIONS

    Fr = (mu*rS*g)/Tm; %Froude number
    Mr = mu*(rS^2)/mS; %Ratio of masses

    %Units (Just for the record)
    Lunit = rS; %Spatial unit of mesurement (in mm)
    Vunit = sqrt(Tm/mu); %Velocity in mm/ms
    Tunit = Lunit/Vunit; %Temporal unit of measurement (in ms)
    Punit = mu * Lunit / Tunit^2; %Unit of pressure (in mg/ms^2)

    %Numerical constants
    N = (ceil(10 * rS)+5); %Number of dx intervals in the spatial (radial) coordinate per unit length
    Ntot = ceil(R_f * N); %Total number of non-trivial points in the spatial coordinate
    dr = 1/N; %Spatial step

    dt = options.RecordedTime/Tunit; %Time step (dimensionless)
    tFinal = options.SimulTime/Tunit; %Maximum time (dimensionless) to be simulated.
    tInit = 0/Tunit; %Initial time (dimensionless)
    rt = dt; %Interval of time to be recorded in the matrix. (1/0.25 = 4 frames per ms)
    ii = 1; %for saving matrix
    mii = ceil((tFinal-tInit)/rt) + 2; %maximum value of ii 

    
    %% Initial Conditions

    z_k_prob = zeros(1, 5); %Initial position of the center of the ball
    v_k_prob = zeros(1, 5); %Initial velocity of the ball (previous and following times)
    Eta_k_prob = zeros(Ntot, 5); %Position of the membrane at different times
    u_k_prob = zeros(Ntot, 5); %Velocities of the membrane at different times
    %errortan = Inf * ones(1, 5);

    P_k = options.P_k; %Current vector of pressures. Only non trivial points saved (Empty vector == membrane and ball should not be touching)
    u_k = zeros(Ntot, 1); %Initial vertical velocity of the membrane (a.k.a. d/dt Eta_k = u_k)
    Eta_k = initial_condition(Fr, dr, Ntot); %Initial position of the membrane
    %------------------------------
    if options.z_k == -1
        z_k = Eta_k(1) + 1; %Curr1ent position of the center of the ball (Dimensionless)
    end
    %------------------------------
    v_k = options.v_k/Vunit;

%     %%%Initial pressures (they are all trivial!)
%     Pk_1 = []; %Possible pressure with two less contact points
%     Pk_2 = []; %Pressure pressure with one less contact point
%     Pk_3 = []; %Possible pressure with the same number of contact points
%     Pk_4 = []; %Possible pressure with one more contact point
%     Pk_5 = []; %Possible pressure with two more contact points


    %% Flow control Variables

    cPoints = length(P_k); %Initial number of contact points
    ctime = 0; %To record contact time
    maxDef = 0; %to record max deflection;
    ch = true; %Boolean to record maximum deflection time
    cVar = false; %To record first contact time
    mCPoints = N + 1; %Maximum number of allowed contact points
    t = tInit; % t is the variable that will keep track of the time
    plotter = options.plotter;
    FileName = fullfile(pwd, "/simulations/"  + options.FileName);
    getNextStep = options.method;

    %Now we save the sphere in an array (For plotting
    width = 3 * N;
    xplot = linspace(0, width/N, width);

    
    %% For post processing

    recordedz_k = zeros(mii, 1);
    recordedEta = zeros(mii, Ntot);
    recordedPk = zeros(mii, mCPoints);
    vars = [str2double(datestr(now, 'MMss')), round(v_k*Vunit, 4), Tm, rS];


    %% Main Loop

    while (ii <= mii)
        errortan = Inf * ones(1, 5);
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
                recordedz_k(ii) = z_k * Lunit;
                recordedEta(ii, :) = Eta_k * Lunit;
                recordedPk(ii, 1:length(P_k)) = P_k * Punit;
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
                hold on;
                xlim([-width*Lunit/N, width*Lunit/N]);
                ylim([(z_k-2)*Lunit, (z_k+2)*Lunit]);
                axis equal;

                plot([-fliplr(xplot(2:end)*Lunit),xplot*Lunit],[flipud(Eta_k(2:width)*Lunit);Eta_k(1:width)*Lunit]','LineWidth',2);
                quiver([-fliplr(xplot(2:end)), xplot] * Lunit, [flipud(Eta_k(2:width));Eta_k(1:width)]' * Lunit,...
                    zeros(1,2*width-1), [flipud(u_k(2:width));u_k(1:width)]' * Vunit);
                title(['   t = ',sprintf('%.5f (ms)', t*Tunit),'   ','nl = ', ...
                    sprintf('%g', cPoints),' vz = ', sprintf('%.5f (mm/ms)', v_k*Vunit)],'FontSize',16);
                drawnow;
            else
                clc;
                disp(['   t = ',sprintf('%.5f (ms)', t*Tunit),'   ','nl = ', ...
                    sprintf('%g', cPoints),' vz = ', sprintf('%.5f (mm/ms)', v_k*Vunit)]);
                fprintf('dt = %f\n', dt);
            end

            %%%%%%%%%%%%
            %%%%%%%%%%%%
            % ANALISE CONTACT TIME AND MAXIMUM DEFLECTION
            
            if (cVar == false && cPoints > 0) % if velocity changed sign
                cVar = true;
                maxDef = z_k;
                dt = rt;
            elseif (cVar == true && cPoints > 0)
                ctime = ctime + dt;
            elseif (cVar == true && cPoints == 0)
                recordedz_k = recordedz_k(1:(ii-1));
                recordedEta = recordedEta(1:(ii-1), :);
                recordedPk = recordedPk(1:(ii-1), :);
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
    
    
    %% POST PROCESSING
    %%%%%%%%%%%%
    if  plotter == true
        close all;
    end

    ctime = round(ctime * Tunit, 5);
    maxDef = round(maxDef * Lunit, 5);
    v_k = vars(2);
    rt = rt * Tunit;
    save(fullfile(pwd, sprintf('/simulations/simul%g_%g_%d.mat', Tm, rS ,vars(1))), ...
        'recordedEta', 'recordedz_k', 'recordedPk', 'ctime', 'maxDef', 'Tm', ...
        'rS', 'rt', 'v_k', 'N');
    
    writematrix([vars, ctime, maxDef], FileName, ...
       'WriteMode', 'append');
    
    fprintf('Contact time: %0.2f (ms)\n', ctime);
    fprintf('Maximum deflection: %0.2f (mm)\n', maxDef);
    fprintf('dt: %0.2f (ms)\n', dt*Tunit);
    fprintf('dr: %0.2f (mm)\n', dr * Lunit);
    disp('-----------------------------');

end