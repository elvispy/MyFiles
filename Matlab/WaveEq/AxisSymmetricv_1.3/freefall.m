function [Eta_k_prob, u_k_prob, z_k_prob, v_k_prob, errortan] = ...
    freefall(Eta_k, u_k, z_k, v_k, dt, dr, Fr, Ntot)

%Lets build the left system
C = 2 * eye(Ntot);
C(1, 1) = 4;
C(1, 2) = -4;
for i = 2:Ntot
   C(i, i-1) = - (2*i-3)/(2*i-2);
   if i < Ntot
       C(i, i+1) = - (2*i-1)/(2*i-2);
   end
end
C = (dt / dr^2) * C;
A = [eye(Ntot), -dt * eye(Ntot);C, eye(Ntot)];
A =[A;zeros(2, 2*Ntot)];
A = [A, zeros(2*Ntot + 2, 2)];
A(end, end) = 1;
A(end-1, end-1) = 1;
A(end-1, end) = -dt;
%disp(A);

%Without gravity
%R = zeros(2*Ntot + 2, 1); R(end) = -Fr * dt;
R = [zeros(Ntot, 1); ones(Ntot, 1) * (-Fr*dt); 0; -Fr*dt];

x = [Eta_k; u_k; z_k; v_k];
%disp(B*x+R);
res = linsolve(A, x+R);

Eta_k_prob = res(1:Ntot);
u_k_prob = res((Ntot + 1):(2*Ntot));
z_k_prob = res(end-1);
v_k_prob = res(end);
%Analytically solving for z_k and v_k
%z_k_prob = z_k + v_k * dt - Fr * dt^2 / 2;
%v_k_prob = v_k - Fr*dt;


%% Now errortan
% i = 0;
% errortan = 0;
% while (i * dr <= 1)
%     if i*i*dr*dr + (Eta_k_prob(i+1) - z_k_prob)^2 < 1 - 1e-9
%         errortan = Inf;
%         break;
%     end
%     i = i + 1;
% end
errortan = 0;
f = @(x) sqrt(1-dr.^2 * x.^2);
ii = 1;
while dr * ii <= 1
    if Eta_k_prob(ii) > z_k_prob - f(ii-1)
        errortan = Inf;
        break;
    end
    ii = ii + 1;
end % end while

end

