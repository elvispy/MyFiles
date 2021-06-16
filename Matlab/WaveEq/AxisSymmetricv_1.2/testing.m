%%Case 1
Eta_test = [1; 2; 3];
u_test = [1; 2; 3];
z_test = 1;
v_test = 1;
dt = 1;
dr = 1;
Fr = 1;
Mr = 1;
Ntot = length(Eta_test);
P_test = [];
mCPoints = Inf;
newCPoints = 0;

cd ..\AxisSymmetricv_1.2\;
[a1, a2, a3, a4, a5] = freefall(Eta_test, u_test, z_test, v_test, P_test, dt, dr, Fr, Mr, Ntot);

cd ..\AxisSymmetricv_1.0\;
[b1, b2, b3, b4, b5] = getNextStep(newCPoints, mCPoints, Eta_test, u_test, ...
    z_test, v_test, P_test, dt, dr, Ntot, Fr, Mr);

%My test
A = [1   0   0 -0.5 0   0   0 0; ...
     0   1   0  0 -0.5  0   0 0; ...
     0   0   1  0   0  -0.5 0 0; ...
     2  -2   0  1   0   0   0 0; ...
    -1/4 1 -3/4 0   1   0   0 0; ...
     0  -3/8 1  0   0   1   0 0; ...
     0   0   0  0   0   0   1 -1/2; ...
     0   0   0  0   0   0   0 1];
 
B = -A + 2 * eye(8);
R = [0;0;0;0;0;0;0;-Fr * dt];
x = [Eta_test;u_test;P_test;z_test;v_test];
res = A\(B*x+R); res = res(1:(end-1)); %Take errortan out for now

assert(all([a1;a2;a3;a4] == [b1;b2;b3;b4]));
assert(all([a1;a2;a3;a4] == res));
assert(all(res == [b1;b2;b3;b4]));
 
 
 %% Case 2
 Eta_test = [1; 2; 3];
u_test = [1; 2; 3];
z_test = 1;
v_test = 1;
dt = 1;
dr = 1;
Fr = 1;
Mr = 1;
Ntot = length(Eta_test);
P_test = [1];
mCPoints = Inf;
newCPoints = 0;

cd ..\AxisSymmetricv_1.2\;
[a1, a2, a3, a4, a5] = freefall(Eta_test, u_test, z_test, v_test, P_test, dt, dr, Fr, Mr, Ntot);

cd ..\AxisSymmetricv_1.0\;
[b1, b2, b3, b4, b5] = getNextStep(newCPoints, mCPoints, Eta_test, u_test, ...
    z_test, v_test, P_test, dt, dr, Ntot, Fr, Mr);

