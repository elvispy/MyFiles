function [Eta_k_prob, u_k_prob, z_k_prob, v_k_prob, errortan] = ...
    freefall(Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Mr, Ntot)

%Lets build the left system
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
A = [eye(Ntot), -dt/2 * eye(Ntot);C, eye(Ntot)];
A =[A;zeros(2, 2*Ntot)];
A = [A, zeros(2*Ntot + 2, 2)];
A(end, end) = 1;
A(end-1, end-1) = 1;
A(end-1, end) = -dt/2;
%%%%%disp(A);
%Now lets build the right system
B_1 = [eye(Ntot);-C;zeros(2, Ntot)];
B_2 = [dt/2 * eye(Ntot);eye(Ntot);zeros(2, Ntot)];
B_3 = [zeros(Ntot); - dt/2 * eye(Ntot); zeros(1, Ntot)];
B_3 = [B_3(:, 1:length(P_k));dt/2 * Mr * int_vector(length(P_k))];
B_4 = zeros(2*Ntot + 2, 2);
B_4(end, end) = 1;
B_4(end-1, end-1) = 1;
B_4(end-1, 2) = dt/2;

B = [B_1, B_2, B_3, B_4];
%%%%%disp(B);
assert(size(B, 1) ==  2*Ntot + 2);

R = zeros(size(B, 1), 1); R(end) = -Fr * dt;
x = [Eta_k; u_k; P_k; z_k; v_k];
%disp(B*x+R);
res = linsolve(A, B*x+R);

Eta_k_prob = res(1:Ntot);
u_k_prob = res((Ntot + 1):(2*Ntot));
z_k_prob = res(end-1);
v_k_prob = res(end);
%Analytically solving for z_k and v_k
%z_k_prob = z_k + v_k * dt - Fr * dt^2 / 2;
%v_k_prob = v_k - Fr*dt;


%% Now errortan
i = 0;
errortan = 0;
while (i * dr <= 1)
    if sqrt(i*i*dr*dr + (Eta_k_prob(i+1+1) - z_k_prob)^2) < 1
        errortan = Inf;
        break;
    end
    i = i + 1;
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