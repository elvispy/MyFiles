function [Eta_k_prob, u_k_prob, z_k_prob, v_k_prob, P_k_prob, errortan] = ...
    solveNcorner(cPoints, Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot)

%First, lets build A
C = eye(Ntot);
C(1, 1) = 2;
C(1, 2) = -2;
for i = 2:Ntot
   C(i, i-1) = -1/2 * (2*i-3)/(2*i-2);
   if i < Ntot
       C(i, i+1) = -1/2 * (2*i-1)/(2*i-2);
   end
end
C = dt / dr^2 * C;

I_M = eye(Ntot);
A_1 = [I_M; C;zeros(2, Ntot)];
residual = A_1(:, 1:cPoints);
A_1 = A_1(:, (cPoints+1):end);

A_2 = [-(dt/2) * I_M; I_M; zeros(2, Ntot)];

A_3 = [zeros(Ntot, Ntot); (dt/2)*I_M; zeros(1, Ntot)];
A_3 = [A_3(:, 1:cPoints); -(dr^2 * dt * Mr/2) * int_vector(cPoints)];

A_4 = [sum(residual, 2), zeros(2*Ntot+2, 1)];
A_4(end, end) = 1;
A_4(end-1, end-1) = 1;
A_4(end-1, end) = -dt/2;

A = [A_1, A_2, A_3, A_4];

%Now building B
B_1 = [I_M; -C; zeros(2, Ntot)];
B_2 = [(dt/2) * I_M; I_M; zeros(2, Ntot)];
B_3 = [zeros(Ntot); -(dt/2) * I_M; zeros(1, Ntot)];
B_3 = [B_3(:, 1:length(P_k)); (dr^2 *dt*Mr/2) * int_vector(length(P_k))];
B_4 = zeros(2*Ntot + 2, 2);
B_4(end, end) = 1;
B_4(end-1, end-1) = 1;
B_4(end-1, end) = dt/2;

B = [B_1, B_2, B_3, B_4];


%Previous time measurements
x = [Eta_k;u_k; P_k; z_k;v_k];

R = [zeros(2*Ntot+1, 1); -Fr*dt];
f = @(x) sqrt(1-x.^2);
pressedPositions = f(dr * (0:(cPoints-1)))';

R_prime = residual * pressedPositions;

results = A\(B*x + R + R_prime);


u_k_prob = results((Ntot-cPoints + 1):(2*Ntot - cPoints));
P_k_prob = results((2*Ntot - cPoints + 1):(2*Ntot));
z_k_prob = results(end-1);
v_k_prob = results(end);
Eta_k_prob = [z_k_prob - pressedPositions; results(1:(Ntot-cPoints))];


%Now lets calculate errortan
g = @(x) x/sqrt(1-x^2); ppt = (cPoints-1)*dr + dr/2;
approximateSlope = (Eta_k_prob(cPoints+1)-Eta_k_prob(cPoints))/dr;
exactSlope = g(ppt);
errortan = abs(atan(approximateSlope) - atan(exactSlope));

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