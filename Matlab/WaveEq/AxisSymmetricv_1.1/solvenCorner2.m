function [Eta_k_prob, u_k_prob, z_k_prob, v_k_prob, P_k_prob, errortan] = ...
    solvenCorner2(newCPoints, mCPoints, Eta_k, u_k, z_k, v_k, P_k, delt, ...
    delr, Ntot, Fr, Mr)

nl = newCPoints;
nlprev = length(P_k);
etao = Eta_k;
phio = u_k;
zo = z_k;
vzo = v_k;
nr = Ntot;
Fr = 1/Fr;
dt = delt;
dr = delr;
Ma = 1/Mr;

A_p = eye(nr);
A_p(1, 2) = -2;
A_p(1, 1) = 2;
for i=2:nr-1
    A_p(i, i+1) = -(1/2) * (2*i-1)/(2*i-2);
    A_p(i, i-1) = -(1/2) * (2*i-3)/(2*i-2);
end
A_p(end, end-1) = -(1/2) * (2*nr -3)/(2*nr-2);

A_p = (delt/delr^2) * A_p;


Int = int_vector(nl);

f = @(x) sqrt(1-(delr^2 * x .* x));
zs = f(0:mCPoints-1)';




%function [etaprob,phiprob,zprob,vzprob,psprob,errortan] = 
%solvenCorner2(nlprev,nl,dt,zo,vzo,etao,phio,nr,dr,Re,Delta,DTN,...
%    Fr,We,Ma,zs,Int,angleDrop,Cang,WeS)
freeplaces = nl+1:nr;
pressedplaces = 1:nl;
b = [etao;phio;P_k; vzo; zo];

%if nlprev < nl
%   AngC = min(angleDrop(nl),pi-Cang);
%else
%    AngC = pi-Cang;
%end

%Deltaprime = [zeros(nl,nr);Delta(nl+1:nr,:)];
Sist = [[eye(nr),-dt/2* eye(nr)];...
    [A_p,eye(nr)]];
%bmod = b-Sist(:,pressedplaces)*zs(pressedplaces);

SistRight = [[eye(nr),dt/2* eye(nr)];...
    [-A_p,eye(nr)]];

SistRight = [[SistRight;zeros(2, 2*nr)], ...
    [zeros(nr, nlprev); -dt/2 * eye(nlprev); zeros(nr-nlprev, nlprev);...
    dt/(2*Ma) * int_vector(nlprev); zeros(1, nlprev)], ...
    [zeros(2*nr, 2);[1, 0; dt/2, 1]]];
b = SistRight*b;

R = [zeros(nr, 1);-dt/Fr * ones(nr+2, 1)];
R(end-1) = 0;

R_p = [Sist(:, pressedplaces) * zs(pressedplaces);0;0];

ds = [[Sist(:,[freeplaces,nr+1:2*nr]),...
    [zeros(nr,nl);dt/2*eye(nl);zeros(nr-nl,nl)],...
    zeros(2*nr,1),Sist(:,pressedplaces)*ones(nl,1)];
    [zeros(1,2*nr-nl),-dt/2*Int(1:nl)/Ma,1,0];
    [zeros(1,2*nr-nl),zeros(1, nl),-dt/2,1]]...
    \(b + R + R_p);

etaprob(freeplaces,1) = ds(1:size(freeplaces,2));
phiprob = ds(size(freeplaces,2)+1:2*nr-nl);
psprob = ds(2*nr-nl+1:2*nr);
vzprob = ds(2*nr+1);
zprob = ds(2*nr+2);
etaprob(pressedplaces,1) = zprob-zs(pressedplaces);

%check = (etaprob(nl+1:end)>(zprob+zs(nl+1:end)));
%if sum(check)>.5
%    errortan = 4;
%else
%taneffect = (etaprob(nl+1)-etaprob(nl))/dr;
%ataneffect = atan(taneffect);
%errortan = angleDrop(nl)-ataneffect-AngC;
%end

aux = dr*(nl - 1) + dr/2;
tanSphere = aux/sqrt(1-aux^2);           
%Lets calculate the approximation of the tangent
approximateTan = (etaprob(nl + 1) - etaprob(nl)) / dr;
errortan = abs(atan(tanSphere) - atan(approximateTan));

%Ahora devuelvo mis variables
Eta_k_prob = etaprob;
u_k_prob = phiprob;
P_k_prob = psprob;
z_k_prob = zprob;
v_k_prob = vzprob;

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