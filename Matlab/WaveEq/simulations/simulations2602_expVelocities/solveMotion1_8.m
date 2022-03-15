
function solveMotion1_8(rS, Tm, R_f, mu, mS, g, options)
    %mainv_1.4
    %Tries to solve the kinematic match between a rigid spherical object
    %and an axissymmetric membran

    %% Handling default values
    arguments
        % All values are assumed to be given with dimensions.
        
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
        g (1, 1) {mustBePositive} = 9.80665e-3 %(mm/ms2);
        
        options.z_k (1, 1) {mustBeReal} = inf % in mm
        options.v_k (1, 1) {mustBeReal} = -0.1 % in mm/ms
        %options.Eta_k (1, :) {mustBeNumeric}
        %options.u_k (1, :) {mustBeNumeric}
        options.P_k (1, :) {mustBeNumeric} = []
        
        options.SimulTime (1, 1) {mustBePositive} = 50 % in ms
        options.RecordedTime (1, 1) = 0 % in ms
        options.N   (1, 1) {mustBeInteger} = 100 % Non-dimensional
        options.FileName (1, 1) string  = "historial.csv"
        options.plotter (1, 1) logical = true
        options.method (1, 1) string {mustBeMember(options.method, ["Euler", "Trapecio"])} = "Euler"
        options.saveAfterContactEnded (1, 1) logical = false
        options.exportData (1, 1) logical = true
    end
    if options.method == "Euler"
        options.method = @eulerSparse1_8;
    elseif options.method == "Trapecio"
        return;
        %options.method = @trapecioMixto;
    end
    if options.saveAfterContactEnded == false
        options.SimulTime = 50; % Change this later on
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
    
    N = options.N; %ceil(2500/R_f);% ceil(10*rS.^(8/5)) + 15;%   %Number of dx intervals in the spatial (radial) coordinate per unit length
    Ntot = ceil(R_f * N); %Total number of non-trivial points in the spatial coordinate
    dr = 1/N; %ceil(R_f/Ntot);% %Spatial step

    % Time flow control variables
    if options.RecordedTime == 0
        dt = 1/(5*N * Tunit);
    else
        dt = options.RecordedTime/Tunit; %Time step (dimensionless)
    end
    finalTime = options.SimulTime/Tunit; %Maximum time (dimensionless) to be simulated.
    tInit = 0/Tunit; %Initial time (dimensionless)
    rt = dt; %Interval of time to be recorded in the matrix. (1/0.25 = 4 frames per ms)
    t = tInit; % t is the variable that will keep track of the time
    currentIndex = 2; %for saving matrix
    
    %For preallocation efficiency
    maximumIndex = ceil((finalTime-tInit)/rt) + 4;
    numberOfExtraIndexes = 0;
    
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
    if options.z_k == inf
        z_k = Eta_k(1) + 1; %Curr1ent position of the center of the ball (Dimensionless)
    else
        assert(options.z_k >= Eta_k(1) + 1, ...
            "La esfera está en una posición inválida!");
        z_k = options.z_k/Lunit;
    end
    ZERO_HEIGHT = Eta_k(1);
    %------------------------------
    v_k = options.v_k/Vunit; % Initial Velocity


    %% Flow control Variables

    cPoints = length(P_k); %Initial number of contact points
    cTime = 0; labcTime = 0; %To record contact time
    maxDef = 0; %to record max deflection;
    ch = true; %Boolean to record maximum deflection time
    contactFlag = false; %To record first contact time
    velocityOutRecorded = false; labvelocityOutRecorded = false;% To check if max deflextion was recorded
    iii = 0; jjj = 0; % Indexes to keep track  of subdivisions of rt 
    resetter = 0;
    mCPoints = N + 1; %Maximum number of allowed contact points
    plotter = options.plotter;
    getNextStep = options.method;
    FileName = fullfile(pwd, "/simulations/"  + options.FileName);
    if exist('simulations', 'dir') ~= 7 % CHeck if folder simulations exists
        mkdir('simulations'); % If not, create it
    end
    if exist(FileName, 'file') == 0 %Check if .csv file exists
        writematrix(["ID", "vi", "surfaceTension", "radius", ...
            "cTime", "maxDeflection", "coefOfRestitution", "Density", ...
            "labcTime", "labcoefOfRestitution"], FileName, ...
            'WriteMode', 'append'); % If not, create it
    end

    %Now we save the sphere in an array (For plotting)
    width = ceil(2.5 * N);
    xplot = linspace(0, width/N, width);
    EtaX = [-fliplr(xplot(2:end)), xplot] * Lunit;
    %EtaU = zeros(1, 2*width - 1);
    %step = ceil(N/15);
    if options.plotter == true
        close all;
        myFigure = figure; 
        axis equal;
        set(gca, ...
          'Box'         , 'on'     , ...
          'FontSize'    , 16        , ...
          'TickDir'     , 'out'     , ...
          'TickLength'  , [.02 .02] , ...
          'XMinorTick'  , 'off'      , ...
          'YMinorTick'  , 'off'      , ...
          'XColor'      , [.3 .3 .3], ...
          'YColor'      , [.3 .3 .3], ...
          'YTick'       , -ceil(2*width*Lunit/N):1:ceil(2*width*Lunit/N), ...
          'XTick'       , -ceil(2*width*Lunit/N):1:ceil(2*width*Lunit/N));
      xlabel('$r/R$', 'Interpreter', 'latex');
      ylabel('$\frac{z}{R}\ \ $', 'Interpreter', 'latex', 'Rotation', 0, ...
          'FontSize', 24);

      xlim([-width*Lunit/N, width*Lunit/N]);
      ylim([-width*Lunit/N + Lunit/2, width*Lunit/N + Lunit/2]);  
      %ylim([(z_k-2)*Lunit, (z_k+2)*Lunit]);
    end  
    

    
    %% For post processing

    % Store recorded values with their dimensions.
    recordedz_k   = zeros(maximumIndex, 1);    recordedz_k(1) = z_k * Lunit;
    recordedEta   = zeros(maximumIndex, Ntot); recordedEta(1, :) = Eta_k * Lunit;
    recordedu_k   = zeros(maximumIndex, Ntot); recordedu_k(1, :) = u_k * Vunit;
    recordedPk    = zeros(maximumIndex, mCPoints); %recordedPk(1, :) = Pk;
    recordedv_k   = zeros(maximumIndex, 1);    recordedv_k(1) = v_k * Vunit;
    recordedTimes = zeros(maximumIndex, 1);    recordedTimes(1) =  tInit * Tunit;
    vars = {datestr(now, 'dddHHMMss'), 0, Tm, rS};
    
    % For coefficient of restitution
    Em_in = nan;
    Em_out = nan; labEm_out = nan;

    AA = cell(mCPoints + 1, 1);
    AA = returnMatrices1_8(AA, Ntot, dr, Mr);
    
    idxsToSave = zeros(maximumIndex, 1); idxsToSave(1) = 1;
    currSaved = 2;
    %% Main Loop
    while (t <= finalTime)
        errortan = Inf * ones(1, 5);
        recalculate = false;

        % If empty, allocate more space.
        if isempty(AA{cPoints + 3}) == true
            AA = returnMatrices1_8(AA, Ntot, dr, Mr);
        end
        %First, we try to solve with the same number of contact points
        [Eta_k_prob(:,3), u_k_prob(:, 3), z_k_prob(3), ...
            v_k_prob(3), Pk_3, errortan(3)] = getNextStep(cPoints, mCPoints, ...
            Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot, AA);

        if abs(errortan(3)) < 1e-8 %If almost no error, we accept the solution
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

            if (abs(errortan(3)) > abs(errortan(4)) || abs(errortan(3)) > abs(errortan(2)))
                if abs(errortan(4)) <= abs(errortan(2))
                    %Now lets check with one more point to be sure
                    [~, ~, ~, ~, ~, errortan(5)] = getNextStep(cPoints + 2, mCPoints, ...
                Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot, AA);

                    if abs(errortan(4)) < abs(errortan(5))
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

                    if abs(errortan(2)) < abs(errortan(1))
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

        if recalculate == true % If calculations didnt go well
            dt = dt/2;
            % Refine time step in index notation
            iii = iii + 1; jjj = 2 * jjj;
        else
            %add time
            t = t + dt; jjj = jjj + 1;
            if mod(jjj, 2) == 0 && resetter > 0
                jjj = jjj/2;
                iii = iii - 1;
                % Increase Time step
                dt = 2*dt;
                %Decrease the number of times you can reset the time
                resetter = resetter - 1;
            end
            
            %%%%%%%%%%%%
            %%%%%%%%%%%%
            %Update Indexes if necessary and store results into a matrix
            
            if currentIndex > maximumIndex
                recordedz_k   = [recordedz_k;   zeros(numberOfExtraIndexes, 1)];
                recordedEta   = [recordedEta;   zeros(numberOfExtraIndexes, Ntot)];
                recordedu_k   = [recordedu_k;   zeros(numberOfExtraIndexes, Ntot)];
                recordedPk    = [recordedPk;    zeros(numberOfExtraIndexes, mCPoints)];
                recordedv_k   = [recordedv_k;   zeros(numberOfExtraIndexes, 1)];
                recordedTimes = [recordedTimes; zeros(numberOfExtraIndexes, 1)];
                maximumIndex = maximumIndex + numberOfExtraIndexes;
                numberOfExtraIndexes = 0;
            end
            
            % Store Data
            recordedz_k(currentIndex) = z_k * Lunit;
            recordedEta(currentIndex, :) = Eta_k * Lunit;
            recordedu_k(currentIndex, :) = u_k * Vunit;
            recordedPk(currentIndex, 1:length(P_k)) = P_k * Punit;
            recordedv_k(currentIndex) = v_k * Vunit;
            recordedTimes(currentIndex) = t * Tunit;
            currentIndex = currentIndex+1; % Set the current index to +1
            
            % If we are in a multiple of rt, reset indexes
            if jjj == 2^iii %Alternatively, 2*mod(t+dt/16, rt) < dt
                %disp(errortan);
                jjj = 0; resetter = 1;
                idxsToSave(currSaved) = currentIndex - 1;
                currSaved = currSaved + 1;
            else
                numberOfExtraIndexes = numberOfExtraIndexes + 1;
            end
            %%%%%%%%%%%%
            %%%%%%%%%%%%
            

            %%%%%%%%%%%%
            %%%%%%%%%%%%
            if plotter == true
                %PLOT 
                %figure(myFigure);
                cla; hold on; grid on;
                %plot(circleX*Lunit,(z_k+circleY)*Lunit,'k','Linewidth',1.5);
                rectangle('Position', [-Lunit, (z_k-1)*Lunit, 2*Lunit, 2*Lunit], ...
                    'Curvature', 1, 'Linewidth', 2);
                
                plot([-width*Lunit/N, width*Lunit/N], [0, 0], '--', 'Color', [.8 .8 .8], 'LineWidth', 2.5);
                EtaY = [flipud(Eta_k(2:width));Eta_k(1:width)]' * Lunit;
                %EtaV = [flipud(u_k(2:width));u_k(1:width)]' * Vunit;
                plot(EtaX,EtaY, 'LineWidth',1.5 , 'Color', [.5 .5 .5]);
                
%                 plot(0, (z_k-1)*Lunit, 'Marker', 'o', 'MarkerSize', 12, ...
%                     'LineWidth', 1, 'Color', [0 0 0]);
%                 plot(0, Eta_k(1)*Lunit, 'Marker', 'o', 'MarkerSize', 4, ...
%                     'MarkerFaceColor', [.3 .3 .3], 'LineWidth', 1.5, 'Color', [.3 .3 .3]);
                if contactFlag == false
                    %quiver(EtaX(1:step:end), EtaY(1:step:end), EtaU(1:step:end), EtaV(1:step:end), 0);
                else
                    %quiver(EtaX(1:step:end), EtaY(1:step:end), EtaU(1:step:end), EtaV(1:step:end));
                end
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
            % ANALISE CONTACT TIME, MAXIMUM DEFLECTION, COEF OF RESTITUTION
            if (contactFlag == false && cPoints > 0) % if contact began, start counting
                contactFlag = true;
                maxDef = recordedz_k(currentIndex - 2, 1); %Store position, remember, it has dimensions!
                vars{2} = round(recordedv_k(currentIndex - 2, 1), 10); % Store initial impact velocity
                zeroPotential = recordedEta(currentIndex - 2, 1) + rS; % Store our zero-Potential 
                Em_in = 1/2 * mS * ((recordedv_k(currentIndex - 2))^2); % Mechanical Energy In;
            elseif (contactFlag == true && ...
                    (velocityOutRecorded == false || labvelocityOutRecorded == false)) % record last contact time
                if recordedz_k(currentIndex - 1) >= Lunit * (ZERO_HEIGHT + 1)
                    if labvelocityOutRecorded == false
                        labEm_out = 1/2 * mS * ((recordedv_k(currentIndex - 1))^2) ...
                            + mS*g*(recordedz_k(currentIndex - 1) - zeroPotential); % Mechanical Energy Out;
                        labvelocityOutRecorded = true;
                    end
                else
                    labcTime = labcTime + dt;
                end
                if cPoints == 0
                    if velocityOutRecorded == false
                        Em_out = 1/2 * mS * ((recordedv_k(currentIndex - 1))^2) ...
                            + mS*g*(recordedz_k(currentIndex - 1) - zeroPotential); % Mechanical Energy Out;
                        velocityOutRecorded = true;
                    end
                else
                    cTime = cTime + dt;
                end
            end
            if options.saveAfterContactEnded == false && ...
                    velocityOutRecorded == true && labvelocityOutRecorded == true
                break; % end simulation if contact ended.
            end
            
            if (contactFlag == true && v_k >= 0) % Record maximum deflection
                if (ch == true) %If velocity has changed sign, record maximum 
                    %deflection only once
                    maxDef = maxDef - recordedz_k(currentIndex - 1);
                    ch = false;
                    if options.plotter == true
%                         tt = text(-2.4, 2.7, '$b)$', 'Interpreter', 'latex', 'FontSize', 16);
%                         print(myFigure, '-depsc', '-r300', 'Graficos/MaximumDeflection.eps');
%                         delete(tt);
                    end
                end
            end
            if contactFlag == true && v_k < 0 && options.saveAfterContactEnded == false ...
                    && ch == false && cPoints > 0
                cTime = inf;
                labcTime = inf;
                break;
            end
            % for plotting purposes
            if contactFlag == true && v_k > 0 && z_k > 1.5 && z_k-v_k*dt < 1.5 && options.plotter == true 
%                 tt = text(-2.4, 2.7, '$d)$', 'Interpreter', 'latex', 'FontSize', 16);
%                 print(myFigure, '-depsc', '-r300', 'Graficos/Fly.eps');
%                 delete(tt);
            end
            
        end     

    end % END WHILE

    %%%%%%%%%%%%
    
    
    %% POST PROCESSING
    %%%%%%%%%%%%
    if options.plotter == true
        delete(myFigure);
    end
    cTime = round(cTime * Tunit, 10); % Round and dimentionalize contact time
    labcTime = round(labcTime * Tunit, 10);
    maxDef = round(maxDef, 10); % Round maximum deflection
    v_k = vars{2}; % Initial velocity is already rounded
    rt = rt * Tunit;
    coefOfRestitution = Em_out/Em_in;
    labcoefOfRestitution = labEm_out/Em_in;
    
    if options.exportData == true 
        %%%
        %%% TODO LO QUE SE EXPORTA ES DIMENSIONAL
        %%%
        
        %Cut data
        idxsToSave = idxsToSave(1:(currSaved-1));
        idxsToSave = idxsToSave(1:3:end); %% BEWARE
        recordedz_k = recordedz_k(idxsToSave);
        recordedEta = recordedEta(idxsToSave, :);
        recordedu_k = recordedu_k(idxsToSave, :);
        recordedPk = recordedPk(idxsToSave, :);
        recordedv_k = recordedv_k(idxsToSave, :);
        recordedTimes = recordedTimes(idxsToSave, :);
        
        % Convert memory-consuming data into single precision
        recordedEta = single(recordedEta);
        recordedu_k = single(recordedu_k);
        
        % Save into a .mat file
        save(fullfile(pwd, sprintf('/simulations/simul%g_%g_%s.mat', Tm, rS ,vars{1})), ...
            'recordedEta', 'recordedu_k', 'recordedz_k', 'recordedPk', 'recordedTimes', ...
            'recordedv_k', 'cTime', 'labcTime', 'maxDef', 'Tm', 'mu', 'rS', 'rt', 'v_k', 'N', ...
            'coefOfRestitution', 'labcoefOfRestitution');
        writecell([vars, cTime, maxDef, coefOfRestitution, 3*mS/(4*pi*rS^3), ...
            labcTime, labcoefOfRestitution], FileName, 'WriteMode', 'append');
    end
    
    % Plot summary into matlab console.
    fprintf('Radius: %0.5f (mm)\n', rS);
    fprintf('Tm: %0.5g \n', Tm);
    fprintf('Contact time: %0.5f (ms)\n', cTime);
    fprintf('Contact time (according to lab procedures): %0.5f (ms)\n', labcTime);
    fprintf('Maximum deflection: %0.5f (mm)\n', maxDef);
    fprintf('Coefficient of Restitution squared: %0.5f \n', coefOfRestitution);
    fprintf('Coefficient of Restitution squared (lab): %0.5f \n', labcoefOfRestitution);
    fprintf('dt: %0.5g (ms)\n', dt*Tunit);
    fprintf('dr: %0.5g (mm)\n', dr * Lunit);
    disp('-----------------------------');

end