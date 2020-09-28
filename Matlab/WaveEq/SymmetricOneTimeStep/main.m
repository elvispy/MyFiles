%In this script we will solve numerically a kinematic match between 
%A perfect sphere and a constant-tension frictionless elastic band. 

clc;
%%

%First, lets define the constans of the problem

N = 50; %Number of poins in the spatial coordinate per unit length
L = 10; %Number of radii in half a length of the rope
Ntot = L * N; %Total Number of non-trivial points in the spatial coordinate}
delx = 1/N; %Spatial step
r = 0.1; %delt/delx
delt = 0.5; %Time Step (in ms)
deltMax = delt; %Maximum number for the value of delt
RS = 2; %Radius of the sphere (in mm)
Tm = 3e+7/1e+6; %Tension of the material (in mg * mm / ms^2)
g = 9806.65/1e+6; %Gravity of earth in mm/ms^2
mu = 1.68; %Density of the material per unit length (in mg/(mm))
mS = 261.3805; %Mass of the ball (in mg)
Lunit = RS; %Spatial unit of measurement
Tunit = Lunit / sqrt(Tm/mu); %Temporal unit of measurement


timeStamps = 0; %Vector of time Stamps
fTime = 500; %Final time to be simulated
z_k = 20 / Lunit; %zk(1) is the current position of the center of the ball
v_k = zeros(1, 1); %derivative of zk at current time
P_k = []; %Vector of pressure. Only non-trivial points are saved. 
Eta_k = zeros(Ntot, 1); %Vector of positions of the rope
u_k = zeros(Ntot, 1); %d/dt Eta_k = u_k

aux = linspace(0, 2*pi, 100);
circleX = RS * cos(aux);
circleY =  RS * sin(aux); %Circle with radius RS to plot

%%
%Now its time to loop and solve the PDE

cPoints = 0; %Number of contact points
mCPoints = N; %Maximum number of contact points
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

constants = [mu * RS * g / Tm, ...
             mu * RS / (2 * Tm * mS), ...
             RS / (2 * Tm)]; 
c1 = mu * RS * g / Tm;
c2 = mu * RS / (2 * Tm * mS);
while (timeStamps < fTime)
    
    recalculate = false;
    %First, we solve with the same number of contact points that of the
    %last time.
    [Eta_k_prob(:,3), u_k_prob(:, 3), z_k_prob(3), ...
        v_k_prob(3), Pk_3, errortan(3)] = solveWithCP(cPoints, mCPoints, Eta_k, u_k, z_k, v_k, ...
        P_k, delt, delx, Ntot, constants);
    
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
            P_k, delt, delx, Ntot, constants);
        
        %Also, lets try with one contact point less.
        [Eta_k_prob(:,2), u_k_prob(:, 2), z_k_prob(2), ...
            v_k_prob(2), Pk_2, errortan(2)] = solveWithCP(cPoints - 1, mCPoints, Eta_k, u_k, z_k, v_k, ...
            P_k, delt, delx, Ntot, constants);
        
        if errortan(3) > errortan(4) || errortan(3) > errortan(2)
            if errortan(4) <= errortan(2)
                %Now lets check if errortan gets better
                [~, ~, ~, ~, ~, errortan(5)] = solveWithCP(cPoints + 2, mCPoints, Eta_k, u_k, z_k, v_k, ...
                P_k, delt, delx, Ntot, constants);

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
                P_k, delt, delx, Ntot, constants);

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
        plotresults(Eta_k, z_k, circleX, circleY, timeStamps, L, RS, delt, Lunit, Tunit);
        timeStamps = timeStamps + delt;
        if 2*delt <= deltMax
            delt = 2 * delt;
        end
    else
        delt = delt/2;
    end

end

disp('Im out at time:');
disp(timeStamps(end));

function plotresults(Eta_k, z_k, circleX, circleY, timeStamps, L, RS, delt, Lunit, Tunit)
    aux = L * RS;
    plot(circleX, circleY + z_k * Lunit, 'Color', 'black', 'LineWidth', 2.5);
    hold on;
    plot(linspace(-aux, aux, 2 * size(Eta_k, 1) - 1), [Eta_k(end:-1:1); ...
       Eta_k(2:end)] * Lunit, 'LineWidth', 3);
    s1 = sprintf("t   =%.3f ms", timeStamps * Tunit);
    s2 = sprintf("z_k =%.3f mm", z_k * Lunit); 
    title({s1, s2}, 'Position', [-aux+5 aux-4 1]);
    axis([-aux aux -aux/2 aux]) 
    hold off;
    pause(delt * Tunit/1000);
end