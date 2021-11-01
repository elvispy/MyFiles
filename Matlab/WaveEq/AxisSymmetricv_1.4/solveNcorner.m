function [Eta_k_prob, u_k_prob, z_k_prob, v_k_prob, P_k_prob, errortan] = ...
    solveNcorner(cPoints, Eta_k, u_k, z_k, v_k, dt, dr, Fr, Mr, Ntot)
    %% Documentation
    % This function solves the one-step kinematic match to calculate the position
    % of the sphere and the elastic band
    % -)cPoints = Number of pressure contact points at time k+1
    % -)Eta_k = Vector of vertical displacement of the rope
    % -)u_k = vector of vertical velocities of the rope
    % -)z_k = vertical position of the center of the ball
    % -)v_k = vertical velocity of the center of the ball
    % -)dt, dx = Temporal and spatial grid minimum difference,
    % respectively
    % -)Ntot = Number of spatial points in half the rope
    % -)constants = a list with the constants needed for the program,
    % containing:
    %     -)Fr = (mu * R * g)/Tm, Frobenius number
    %     -)Mr = mu * R^2 / m
    %LHS of the PDE
    %Outputs:
    % -)Eta_k_prob = Vector of vectical position of the band
    % -)u_k_prob = vector of vertical velocities of the band
    % -)z_k_prob = Position of the center of the sphere
    % -)v_k_prob = Vertical velocity of the center of the ball
    % -)P_k_prob = pressures applied against the ball.
    % errortan = Error associated to the angle after contact point

%% Building A

%First column block (Eta_k)
A_prime = 2*eye(Ntot);
A_prime(1, 1) = 4;
A_prime(1, 2) = -4;
for i = 2:Ntot
   A_prime(i, i-1) = -(2*i-3)/(2*i-2);
   if i < Ntot
       A_prime(i, i+1) = -(2*i-1)/(2*i-2);
   end
end
A_prime = (dt / dr^2) * A_prime;

I_M = eye(Ntot);
A_1 = [I_M; A_prime;zeros(2, Ntot)];
residual_1 = A_1(:, 1:cPoints);
A_1 = A_1(:, (cPoints+1):end);

%Second colum block (u_k)
A_2 = [-dt* I_M; I_M; zeros(2, Ntot)];
residual_2 = A_2(:, 1:cPoints);
A_2 = A_2(:, (cPoints+1):end);

%Third column block (P_k)
A_3 = [zeros(Ntot, Ntot); dt*I_M; zeros(1, Ntot)];
A_3 = [A_3(:, 1:cPoints); -(dr^2 * dt * Mr) * int_vector(cPoints)];

%Now last columns (z_k and v_k)
A_4 = [sum(residual_1, 2), sum(residual_2, 2)];
A_4(end, end) = 1;
A_4(end-1, end-1) = 1;
A_4(end-1, end) = -dt;

A = [A_1, A_2, A_3, A_4];
A = A((cPoints + 1):end, :);


%% Building R and R_prime
R = [zeros(Ntot - cPoints, 1); (-Fr * dt) * ones(Ntot, 1); 0 ; -Fr * dt];
f = @(x) sqrt(1-dr^2 * x.^2);

R_prime = residual_1 * (f(0:(cPoints-1))');
R_prime = R_prime((cPoints+1):end);

%% Solving the system
x = [Eta_k;u_k; z_k;v_k]; x = x((cPoints+1):end);
results = A\(x + R + R_prime);

z_k_prob = results(end-1);
v_k_prob = results(end);
Eta_k_prob = [z_k_prob - (f(0:(cPoints-1))'); results(1:(Ntot-cPoints))];

u_k_prob = v_k_prob * ones(cPoints, 1);
u_k_prob = [u_k_prob; results((Ntot-cPoints + 1):(2*Ntot - 2 * cPoints))];
P_k_prob = results((2*Ntot - 2 * cPoints + 1):(2*Ntot - cPoints));


%% Calculating errortan
g = @(x) x/sqrt(1-x^2); ppt = (cPoints-1)*dr + dr/2;
approximateSlope = (Eta_k_prob(cPoints+1)-Eta_k_prob(cPoints))/dr;
exactSlope = g(ppt);
errortan = abs(atan(approximateSlope) - atan(exactSlope));

%% Test 2
% i = 0;
% while (i * dr <= 1)
%     if i*i*dr*dr + (Eta_k_prob(i+1) - z_k_prob)^2 < 1 - 1e-9
%         errortan = Inf;
%         break;
%     end
%     i = i + 1;
% end
ii = cPoints + 1;
while ii * dr <= 1
    if Eta_k_prob(ii) > z_k_prob - f(ii-1)
        errortan = Inf;
        break;
    end
    ii = ii + 1;
end

end


function S = int_vector(n)
    %THe integration vector without dhe dr^2 factor
    if n == 0
        S = [];
    elseif n == 1
        S = [pi/12];
    else
        S = (pi) * ones(1, n);
        S(1) = 1/3 * S(1);
        for i = 2:(n-1)
            S(i) = 2*(i-1) * S(i);
        end
        S(n) = (3/2 * (n - 1) - 1/4) * S(n);
    end
end