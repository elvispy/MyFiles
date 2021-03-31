%In this script we will solve numerically a kinematic match between 
%A perfect sphere and a constant-tension frictionless elastic band. 

clc;
%%

%First, lets define the constans of the problem
%Physical constants
RS = 2; %Radius of the sphere (in mm)
L = 10; %Number of radii in half a length of the rope
Tm = 3e+7/1e+6; %Tension of the material (in mg * mm / ms^2)
g = 9.80665/1e+3; %Gravity of earth in mm/ms^2
mu = 0.0168; %Density of the rope per unit length (in mg/(mm))
mS = 98.0176; %Mass of the ball (in mg)

%Units
Lunit = RS; %Spatial unit of measurement
Vunit = sqrt(Tm/mu); %in mm/ms
Tunit = Lunit/Vunit; %Temporal unit of measurement (in ms)
Punit = mu * Lunit/Tunit^2; %Unit pressure (mg/(ms)^2)

%Numerical constants
N = 20; %Number of dx intervals in the spatial coordinate per unit length
Ntot = L * N; %Total Number of non-trivial points in the spatial coordinate}
delx = 1/N; %Spatial step
r = 0.5; %delt/delx
delt = delx*r; %Time Step dimensionless
deltMax = delt; %Maximum number for the value of delt (dimensionless)




timeStamps = 0; %Vector of time Stamps

fTime = 20; %Final time to be simulated (included unit of measurement)
fTime = floor(fTime/Tunit); %Final time to simulate (dimensionless)
midx = ceil(fTime/deltMax);
z_k = 1.1;%20 / Lunit; %zk(1) is the current position of the center of the ball (dimensionless)
v_k = -.72/Vunit;%zeros(1, 1); %derivative of zk at current time
P_k = []; %Vector of pressure. Only non-trivial points are saved. 
Eta_k = zeros(Ntot, 1); %Vector of positions of the rope
u_k = zeros(Ntot, 1); %d/dt Eta_k = u_k

currentTime = deltMax; %Current time to be saved
curridx = 2; %Index to be appended 
MatResult = zeros(Ntot, midx);
zResult = zeros(midx, 1);

aux = linspace(0, 2*pi, 100);
circleX = RS * cos(aux);
circleY =  RS * sin(aux); %Circle with radius RS to plot

%%
%Now its time to loop and solve the PDE

cPoints = 0; %Number of contact points
mCPoints = N+1; %Maximum number of contact points
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


         
Fr = Tm/(mu*RS*g); %Froude number
Ma = mu*RS/mS; %Ratio of masses

%First, lets save the initial conditions into the results
MatResult(:, 1) = Eta_k;
zResult(1) = z_k;
tic;
while (curridx <= midx)

    recalculate = false;
    errortan = Inf * ones(1, 5);
    %First, we solve with the same number of contact points that of the
    %last time.
    [Eta_k_prob(:,3), u_k_prob(:, 3), z_k_prob(3), ...
        v_k_prob(3), Pk_3, errortan(3)] = solveWithCP(cPoints, mCPoints, Eta_k, u_k, z_k, v_k, ...
        P_k, delt, delx, Ntot, Fr, Ma);
    
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
            P_k, delt, delx, Ntot, Fr, Ma);
        
        %Also, lets try with one contact point less.
        [Eta_k_prob(:,2), u_k_prob(:, 2), z_k_prob(2), ...
            v_k_prob(2), Pk_2, errortan(2)] = solveWithCP(cPoints - 1, mCPoints, Eta_k, u_k, z_k, v_k, ...
            P_k, delt, delx, Ntot, Fr, Ma);
        
        if errortan(3) > errortan(4) || errortan(3) > errortan(2)
            if errortan(4) <= errortan(2)
                %Now lets check if errortan gets better
                [~, ~, ~, ~, ~, errortan(5)] = solveWithCP(cPoints + 2, mCPoints, Eta_k, u_k, z_k, v_k, ...
                P_k, delt, delx, Ntot, Fr, Ma);

                if errortan(4) < errortan(5)
                    Eta_k = Eta_k_prob(:, 4);
                    u_k = u_k_prob(:, 4);
                    z_k = z_k_prob(4);
                    v_k = v_k_prob(4);
                    P_k = Pk_4;
                    cPoints = cPoints + 1;

                else
                    recalculate = true;
                end

            else
                %Now lets check if errortan gets better
                [~, ~, ~, ~, ~, errortan(1)] = solveWithCP(cPoints - 2, mCPoints, Eta_k, u_k, z_k, v_k, ...
                P_k, delt, delx, Ntot, Fr, Ma);

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
        else %the same number of contact points is the best solution
            Eta_k = Eta_k_prob(:, 3);
            u_k = u_k_prob(:, 3);
            z_k = z_k_prob(3);
            v_k = v_k_prob(3);
            P_k = Pk_3;
    
        end

    end
    if recalculate == false
        if cPoints == 1
            disp("Hola")
        end
        plotresults(Eta_k, z_k, v_k, circleX, circleY, timeStamps, L, RS, delt, Lunit, Tunit, Vunit);
        timeStamps = timeStamps + delt;
        if timeStamps >= currentTime    
            %MatResult(:, curridx) = Eta_k;
            %zResult(curridx) = z_k;
            curridx = curridx + 1;
            currentTime = currentTime + deltMax;
        end
        if delt < deltMax
            delt = 2 * delt;
        end
        %clc;
        %fprintf("%d, %.3f, \n", cPoints, delt);
    else
        delt = delt/2;
    end
    

end

%save('positions.mat', 'MatResult', 'zResult', 'deltMax');
fprintf('Time spent %3.2f\n', toc);
%Lets plot the results
%for i = 1:midx
%    plotresults(MatResult(:, i), zResult(i), circleX, circleY, (i-1) * deltMax, ...
%                L, RS, deltMax, Lunit, Tunit);
%    
%end


function plotresults(Eta_k, z_k, v_k, circleX, circleY, timeStamps, L, RS, ...
    delt, Lunit, Tunit, Vunit)
    aux = L * RS;
    plot(circleX, circleY + z_k * Lunit, 'Color', 'black', 'LineWidth', 2.5);
    hold on;
    plot(linspace(-aux, aux, 2 * size(Eta_k, 1) + 1), [0; Eta_k(end:-1:1); ...
       Eta_k(2:end); 0] * Lunit, 'LineWidth', 3);
    s1 = sprintf("t   =%.2f ms", timeStamps * Tunit);
    s2 = sprintf("z_k =%.2f mm", z_k * Lunit); 
    s3 = sprintf("  v_k =%.2f mm/ms", v_k*Vunit);
    title({s1, s2, s3}, 'Position', [-aux+5 aux-6 1]);
    axis([-aux aux -aux/2 aux]) 
    hold off;
    grid on
    pause(delt * Tunit/1000);
end