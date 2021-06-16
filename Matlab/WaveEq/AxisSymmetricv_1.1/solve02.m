function [Eta_k_prob, u_k_prob, z_k_prob, v_k_prob, P_k_prob, errortan] = ...
    solve02(mCPoints, Eta_k, u_k, z_k, v_k, P_k, delt, delr, Ntot, Fr)

nr = Ntot;
etao = Eta_k;
phio = u_k;
dt = delt;
vz = v_k;
z = z_k;
Fr = 1/Fr; %Nuestras constantes de Freude son reciprocas!
oldCPoints = length(P_k);

A_p = eye(nr);
A_p(1, 2) = -2;
A_p(1, 1) = 2;
for i=2:nr-1
    A_p(i, i+1) = -(1/2) * (2*i-1)/(2*i-2);
    A_p(i, i-1) = -(1/2) * (2*i-3)/(2*i-2);
end
A_p(end, end-1) = -(1/2) * (2*nr -3)/(2*nr-2);

A_p = (delt/delr^2) * A_p;

f = @(x) sqrt(1-(delr^2 * x .* x));
zs = f(0:mCPoints-1)';



%%Desde aca es codigo de Carlos
%function [etaprob0,phiprob0,zprob0,vzprob0,errortan]=solve02(dt,z,vz,etao,phio,nr,Re,Delta,DTN,Fr,We,zs)
b = [etao;phio;P_k];

Sist = [eye(nr),-dt*eye(nr)/2;...
    [A_p,eye(nr)]];
SistRight = [[eye(nr), dt/2 * eye(nr), zeros(nr, oldCPoints)];...
    [-A_p, eye(nr), [-dt/2 * eye(oldCPoints); zeros(nr- oldCPoints, oldCPoints)]]];
c = (Sist\(SistRight *b));

etaprob0 = c(1:nr);
phiprob0 = c(nr+1:2*nr);

vzprob0 = vz-dt/Fr;
%Finding new eta
zprob0 = z+vz*dt-dt^2/(2*Fr);
check = (etaprob0(1:mCPoints)>(zprob0-zs));
errortan = 0;
if sum(check)>.5
    errortan = Inf;
end

%Devuelvo mis variables
Eta_k_prob = etaprob0;
u_k_prob = phiprob0;
z_k_prob = zprob0;
v_k_prob = vzprob0;
P_k_prob = [];
end

%% Integration vector definition
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