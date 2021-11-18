
function mainFunction1_6(rS, Tm, R_f, mu, mS, g, options)
    %mainv_1.4
    %Tries to solve the kinematic match with getNextStep

    %% Handling default values
    arguments
        % All values have dimensions.
        
        %Radius of the sphere (in mm)
        rS (1, 1) {mustBePositive} = 1
        %Tension of the material (in mg / ms^2)
        Tm (1, 1) {mustBePositive} = 73
        %Number of raddi in half a length of the membrane (dimensionless)
        R_f (1, 1) {mustBePositive} = 52.4/rS
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
        options.saveAfterContactEnded (1, 1) logical = false
        options.exportData (1, 1) logical = true
    end
    if options.method == "Euler"
        options.method = @eulerSparse1_6;
    elseif options.method == "Trapecio"
        return;
        %options.method = @trapecioMixto;
    end

    
    %% CONSTANTS' DEFINITIONS

    Fr = (mu*rS*g)/Tm; %Froude number
    Mr = mu*(rS^2)/mS; %Ratio of masses

    %Units (Just for the record)
    Lunit = rS; %Spatial unit of mesurement (in mm)
    Vunit = sqrt(Tm/mu); %Velocity in mm/ms
    Tunit = Lunit/Vunit; %TempSoral unit of measurement (in ms)
    Punit = mu * Lunit / Tunit^2; %Unit of pressure (in mg/(ms^2 * mm))

    %Numerical constants
    N = ceil(1000/R_f);% ceil(10*rS.^(8/5)) + 15;%   %Number of dx intervals in the spatial (radial) coordinate per unit length
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
    else
        assert(options.z_k >= Eta_k(1) + 1, ...
            "La esfera está en una posición inválida!");
        z_k = options.z_k/Lunit;
    end
    %------------------------------
    v_k = options.v_k/Vunit;


    %% Flow control Variables

    cPoints = length(P_k); %Initial number of contact points
    ctime = 0; %To record contact time
    maxDef = 0; %to record max deflection;
    ch = true; %Boolean to record maximum deflection time
    cVar = false; %To record first contact time
    mCPoints = N + 1; %Maximum number of allowed contact points
    t = tInit; % t is the variable that will keep track of the time
    plotter = options.plotter;
    getNextStep = options.method;
    FileName = fullfile(pwd, "/simulations/"  + options.FileName);
    if exist('simulations', 'dir') ~= 7
        mkdir('simulations');
    end
    if exist(FileName, 'file') == 0
        writematrix(["ID", "vi", "surfaceTension", "radius", ...
            "cTime", "maxDeflection"], FileName, ...
            'WriteMode', 'append');
    end

    %Now we save the sphere in an array (For plotting
    width = 3 * N;
    xplot = linspace(0, width/N, width);
    EtaX = [-fliplr(xplot(2:end)), xplot] * Lunit;
    EtaU = zeros(1, 2*width - 1);
    step = ceil(N/15);

    
    %% For post processing

    recordedz_k = zeros(mii, 1);
    recordedEta = zeros(mii, Ntot);
    recordedPk = zeros(mii, mCPoints);
    vars = [str2double(datestr(now, 'MMss')), 0, Tm, rS];

    AA = returnMatrices1_6(mCPoints, Ntot, dr, Mr);

    %% Main Loop
    while (ii <= mii)
        errortan = Inf * ones(1, 5);
        recalculate = false;

        %First, we try to solve with the same number of contact points
        [Eta_k_prob(:,3), u_k_prob(:, 3), z_k_prob(3), ...
            v_k_prob(3), Pk_3, errortan(3)] = getNextStep(cPoints, mCPoints, ...
            Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot, AA);

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
                Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot, AA);

            %Lets try with one point less
            [Eta_k_prob(:,2), u_k_prob(:, 2), z_k_prob(2), ...
                v_k_prob(2), Pk_2, errortan(2)] = getNextStep(cPoints - 1, mCPoints, ...
                Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot, AA);

            if (errortan(3) > errortan(4) || errortan(3) > errortan(2))
                if errortan(4) <= errortan(2)
                    %Now lets check with one more point to be sure
                    [~, ~, ~, ~, ~, errortan(5)] = getNextStep(cPoints + 2, mCPoints, ...
                Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot, AA);

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
                Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot, AA);

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
            if mod(t+dt/8, rt) < dt
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
                
                EtaY = [flipud(Eta_k(2:width));Eta_k(1:width)]' * Lunit;
                EtaV = [flipud(u_k(2:width));u_k(1:width)]' * Vunit;
                plot(EtaX,EtaY,'LineWidth',2);
                quiver(EtaX(1:step:end), EtaY(1:step:end), EtaU(1:step:end), EtaV(1:step:end));
                title(['   t = ',sprintf('%.5f (ms)', t*Tunit),'   ','nl = ', ...
                    sprintf('%g', cPoints),' vz = ', sprintf('%.5f (mm/ms)', v_k*Vunit)],'FontSize',16);
                drawnow;
            else
                clc;
                disp(['   t = ',sprintf('%.5f (ms)', t*Tunit),'   ','nl = ', ...
                    sprintf('%g', cPoints),' vz = ', sprintf('%.5f (mm/ms)', v_k*Vunit)]);
            end
            %%%%%%%%%%%%
            %%%%%%%%%%%%
            
            % ANALISE CONTACT TIME AND MAXIMUM DEFLECTION
            
            if (cVar == false && cPoints > 0) % if velocity changed sign
                cVar = true;
                maxDef = z_k;
                vars(2) = round(v_k * Vunit, 5);
                %dt = rt;
            elseif (cVar == true && cPoints > 0) % count for contact time
                ctime = ctime + dt;
            elseif (cVar == true && cPoints == 0 ...
                    && options.saveAfterContactEnded == false) % end contact
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
    
    if options.exportData == true 
        save(fullfile(pwd, sprintf('/simulations/simul%g_%g_%d.mat', Tm, rS ,vars(1))), ...
            'recordedEta', 'recordedz_k', 'recordedPk', 'ctime', 'maxDef', 'Tm', ...
            'rS', 'rt', 'v_k', 'N');

        writematrix([vars, ctime, maxDef], FileName, ...
           'WriteMode', 'append');
    end
    fprintf('Radius: %0.2f (mm)\n', rS);
    fprintf('Tm: %0.2g \n', Tm);
    fprintf('Contact time: %0.5f (ms)\n', ctime);
    fprintf('Maximum deflection: %0.5f (mm)\n', maxDef);
    fprintf('dt: %0.5g (ms)\n', dt*Tunit);
    fprintf('dr: %0.5g (mm)\n', dr * Lunit);
    disp('-----------------------------');

end