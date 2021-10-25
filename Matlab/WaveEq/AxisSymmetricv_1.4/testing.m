%% Test: No contact points before and after
% 
Eta_test = [1; 2; 3];
u_test = [1; 2; 3];
z_test = 1;
v_test = 1;
dt = 1;
dr = 1;
Fr = 1;
%Mr = 1;
Ntot = length(Eta_test);
%P_test = [];
%mCPoints = Inf;
%newCPoints = 0;

cd ..\AxisSymmetricv_1.3\;
[a1, a2, a3, a4, a5] = freefall(Eta_test, u_test, z_test, v_test, dt, dr, Fr, Ntot);

%My test
A = [1   0   0 -1   0   0   0 0; ...
     0   1   0  0  -1   0   0 0; ...
     0   0   1  0   0  -1   0 0; ...
     4  -4   0  1   0   0   0 0; ...
    -1/2 2 -3/2 0   1   0   0 0; ...
     0  -3/4 2  0   0   1   0 0; ...
     0   0   0  0   0   0   1,-1; ...
     0   0   0  0   0   0   0 1];
 

R = [0;0;0;0;0;0;0;-Fr * dt];
x = [Eta_test;u_test;z_test;v_test];
res = A\(x+R);


assert(all([a1;a2;a3;a4] == res));


 %% Test: One contact point and then no contact points
Eta_test = [1; 2; 3];
u_test = [1; 2; 3];
z_test = 1;
v_test = 1;
dt = 1;
dr = 1;
Fr = 1;
%Mr = 1;
Ntot = length(Eta_test);
%P_test = [1];
%mCPoints = Inf;
%newCPoints = 0;

cd ..\AxisSymmetricv_1.3\;
[a1, a2, a3, a4, a5] = freefall(Eta_test, u_test, z_test, v_test, dt, dr, Fr, Ntot);


%My test
A = [1   0   0 -1   0   0   0 0; ...
     0   1   0  0  -1   0   0 0; ...
     0   0   1  0   0  -1   0 0; ...
     4  -4   0  1   0   0   0 0; ...
    -1/2 2 -3/2 0   1   0   0 0; ...
     0  -3/4 2  0   0   1   0 0; ...
     0   0   0  0   0   0   1 -1; ...
     0   0   0  0   0   0   0 1];
 

R = [0;0;0;0;0;0;0;-Fr * dt];
x = [Eta_test;u_test;z_test;v_test];
res = A\(x+R); 


assert(all([a1;a2;a3;a4] == res));


%% Test: Two contact points before and after
Eta_test = [1; 2; 3; 4];
u_test = [1; 2; 3; 4];
z_test = 1;
v_test = 1;
dt = 1;
dr = 1;
Fr = 1;
Mr = 1;
Ntot = length(Eta_test);
%P_test = [1; 1];
%mCPoints = Inf;
newCPoints = 2;

%cd ..\AxisSymmetricv_1.2\;
[a1, a2, a3, a4, a5] = solveNcorner(newCPoints, Eta_test, u_test, z_test, v_test, dt, dr, Fr, Mr, Ntot);

% My test
A_1 = [1  0; ...
       0  1; ...
       0  0; ...
       0  0; ...
       4 -4; ...
     -1/2,2; ...
       0,-3/4; ...
       0  0; ...
       0  0; ...
       0  0];
  
A = [0   0,  -1   0   0   0,   0   0,     1  0; ...
     0   0,   0  -1   0   0,   0   0,     1  0; ...
     1   0,   0   0  -1   0,   0   0,     0  0; ...
     0   1,   0   0   0  -1,   0   0,     0  0;...
     0   0,   1   0   0   0,   1   0,     0  0; ...
   -3/2  0,   0   1   0   0,   0   1,    3/2 0; ...
     2 -5/4,  0   0   1   0,   0   0,   -3/4 0; ...
   -5/6  2,   0   0   0   1,   0   0,     0  0; ...
     0   0,   0   0   0   0,   0   0,     1 -1; ...
     0   0,   0   0   0   0,-pi/3,-5*pi/4,0  1];

 

R = zeros(10, 1); R(end) = -Fr * dt;
x = [Eta_test;u_test;z_test;v_test];
aux = [1 sqrt(1-dr^2)]';
R_pp = A_1 * aux;
res = A\(x+R+R_pp); 
res = [res(end-1) - aux; res];


assert(all([a1;a2;a5;a3;a4] == res));


%% Test: One contact point and then two contact points
Eta_test = [1; 2; 3; 4];
u_test = [1; 2; 3; 4];
z_test = 1;
v_test = 1;
dt = 1;
dr = 1;
Fr = 1;
Mr = 1;
Ntot = length(Eta_test);
%P_test = [1];
%mCPoints = Inf;
newCPoints = 2;


%cd ..\AxisSymmetricv_1.2\;
[a1, a2, a3, a4, a5] = solveNcorner(newCPoints, Eta_test, u_test, z_test, v_test, dt, dr, Fr, Mr, Ntot);

%My test

A_1 = [1  0; ...
       0  1; ...
       0  0; ...
       0  0; ...
       4 -4; ...
     -1/2,2; ...
       0,-3/4; ...
       0  0; ...
       0  0; ...
       0  0];
  
A = [0   0,  -1   0   0   0,   0   0,     1  0; ...
     0   0,   0  -1   0   0,   0   0,     1  0; ...
     1   0,   0   0  -1   0,   0   0,     0  0; ...
     0   1,   0   0   0  -1,   0   0,     0  0;...
     0   0,   1   0   0   0,   1   0,     0  0; ...
   -3/2  0,   0   1   0   0,   0   1,    3/2 0; ...
     2 -5/4,  0   0   1   0,   0   0,   -3/4 0; ...
   -5/6  2,   0   0   0   1,   0   0,     0  0; ...
     0   0,   0   0   0   0,   0   0,     1 -1; ...
     0   0,   0   0   0   0,-pi/3,-5*pi/4,0  1];

 
R = zeros(10, 1); R(end) = -Fr * dt;
x = [Eta_test;u_test;z_test;v_test];
aux = [1 sqrt(1-dr^2)]';
R_pp = A_1 * aux;
res = A\(x+R+R_pp); 

res = [res(end-1) - aux; res];


assert(all([a1;a2;a5;a3;a4] == res));

 
%% Test: No contact point and then one contact point
Eta_test = [1; 2; 3; 4];
u_test = [1; 2; 3; 4];
z_test = 1;
v_test = 1;
dt = 1;
dr = 1;
Fr = 1;
Mr = 1;
Ntot = length(Eta_test);
%P_test = [];
%mCPoints = Inf;
newCPoints = 1;


%cd ..\AxisSymmetricv_1.2\;
[a1, a2, a3, a4, a5] = solveNcorner(newCPoints, Eta_test, u_test, z_test, v_test, dt, dr, Fr, Mr, Ntot);

%My test

A_1 = [1;0;0;0;4;-1/2;0;0;0;0];
  
A = [0   0   0,  -1   0   0   0,   0,  1  0; ...
     1   0   0,   0  -1   0   0,   0,  0  0; ...
     0   1   0,   0   0  -1   0,   0,  0  0; ...
     0   0   1,   0   0   0  -1,   0,  0  0;...
    -4   0   0,   1   0   0   0,   1,  4  0; ...
     2 -3/2  0,   0   1   0   0,   0 -1/2 0; ...
   -3/4  2 -5/4,  0   0   1   0,   0,  0  0; ...
     0 -5/6  2,   0   0   0   1,   0,  0  0; ...
     0   0   0,   0   0   0   0,   0,  1 -1; ...
     0   0   0,   0   0   0   0,-pi/12,0  1];

 

R = zeros(10, 1); R(end) = -Fr * dt;
x = [Eta_test;u_test;z_test;v_test];
aux = 1;
R_pp = A_1 * aux;
res = A\(x+R+R_pp); 

res = [res(end-1) - aux; res];

assert(all([a1;a2;a5;a3;a4] == res));

 
 %% Test: Three contact points and then two contact points
Eta_test = [1; 2; 3; 4];
u_test = [1; 2; 3; 4];
z_test = 1;
v_test = 1;
dt = 1;
dr = 1;
Fr = 1;
Mr = 1;
Ntot = length(Eta_test);
%P_test = [1 2 3]';
%mCPoints = Inf;
newCPoints = 2;

%cd ..\AxisSymmetricv_1.2\;
[a1, a2, a3, a4, a5] = solveNcorner(newCPoints, Eta_test, u_test, z_test, v_test, dt, dr, Fr, Mr, Ntot);

%My test
A_1 = [1  0; ...
       0  1; ...
       0  0; ...
       0  0; ...
       4 -4; ...
     -1/2,2; ...
       0,-3/4; ...
       0  0; ...
       0  0; ...
       0  0];
  
A = [0   0,  -1   0   0   0,   0   0,     1  0; ...
     0   0,   0  -1   0   0,   0   0,     1  0; ...
     1   0,   0   0  -1   0,   0   0,     0  0; ...
     0   1,   0   0   0  -1,   0   0,     0  0;...
     0   0,   1   0   0   0,   1   0,     0  0; ...
   -3/2  0,   0   1   0   0,   0   1,    3/2 0; ...
     2 -5/4,  0   0   1   0,   0   0,   -3/4 0; ...
   -5/6  2,   0   0   0   1,   0   0,     0  0; ...
     0   0,   0   0   0   0,   0   0,     1 -1; ...
     0   0,   0   0   0   0,-pi/3,-5*pi/4,0  1];

 

R = zeros(10, 1); R(end) = -Fr * dt;
x = [Eta_test;u_test;z_test;v_test];
aux = [1 sqrt(1-dr^2)]';
R_pp = A_1 * aux;
res = A\(x+R+R_pp); 

res = [res(end-1) - aux; res];


assert(all([a1;a2;a5;a3;a4] == res));


 %% Test: Three contact points and then one contact point
 
Eta_test = [1; 2; 3; 4];
u_test = [1; 2; 3; 4];
z_test = 1;
v_test = 1;
dt = 1;
dr = 1;
Fr = 1;
Mr = 1;
Ntot = length(Eta_test);
%P_test = [1 2 3]';
%mCPoints = Inf;
newCPoints = 1;

%cd ..\AxisSymmetricv_1.2\;
[a1, a2, a3, a4, a5] = solveNcorner(newCPoints, Eta_test, u_test, z_test, v_test, dt, dr, Fr, Mr, Ntot);

%My test

A_1 = [1;0;0;0;4;-1/2;0;0;0;0];
  
A = [0   0   0,  -1   0   0   0,   0,  1  0; ...
     1   0   0,   0  -1   0   0,   0,  0  0; ...
     0   1   0,   0   0  -1   0,   0,  0  0; ...
     0   0   1,   0   0   0  -1,   0,  0  0;...
    -4   0   0,   1   0   0   0,   1,  4  0; ...
     2 -3/2  0,   0   1   0   0,   0 -1/2 0; ...
   -3/4  2 -5/4,  0   0   1   0,   0,  0  0; ...
     0 -5/6  2,   0   0   0   1,   0,  0  0; ...
     0   0   0,   0   0   0   0,   0,  1 -1; ...
     0   0   0,   0   0   0   0,-pi/12,0  1];

 
R = zeros(10, 1); R(end) = -Fr * dt;
x = [Eta_test;u_test;z_test;v_test];
aux = 1;
R_pp = A_1 * aux;
res = A\(x+R+R_pp); 

res = [res(end-1) - aux; res];

assert(all([a1;a2;a5;a3;a4] == res));


 %% Test: No contact point and then two contact points
 
Eta_test = [1; 2; 3; 4];
u_test = [1; 2; 3; 4];
z_test = 1;
v_test = 1;
dt = 1;
dr = 1;
Fr = 1;
Mr = 1;
Ntot = length(Eta_test);
%P_test = [];
%mCPoints = Inf;
newCPoints = 2;


[a1, a2, a3, a4, a5] = solveNcorner(newCPoints, Eta_test, u_test, z_test, v_test, dt, dr, Fr, Mr, Ntot);

%My test

A_1 = [1  0; ...
       0  1; ...
       0  0; ...
       0  0; ...
       4 -4; ...
     -1/2,2; ...
       0,-3/4; ...
       0  0; ...
       0  0; ...
       0  0];
  
A = [0   0,  -1   0   0   0,   0   0,     1  0; ...
     0   0,   0  -1   0   0,   0   0,     1  0; ...
     1   0,   0   0  -1   0,   0   0,     0  0; ...
     0   1,   0   0   0  -1,   0   0,     0  0;...
     0   0,   1   0   0   0,   1   0,     0  0; ...
   -3/2  0,   0   1   0   0,   0   1,    3/2 0; ...
     2 -5/4,  0   0   1   0,   0   0,   -3/4 0; ...
   -5/6  2,   0   0   0   1,   0   0,     0  0; ...
     0   0,   0   0   0   0,   0   0,     1 -1; ...
     0   0,   0   0   0   0,-pi/3,-5*pi/4,0  1];

 
 

R = zeros(10, 1); R(end) = -Fr * dt;
x = [Eta_test;u_test;z_test;v_test];
aux = [1 sqrt(1-dr^2)]';
R_pp = A_1 * aux;
res = A\(x+R+R_pp); 

res = [res(end-1) - aux; res];

assert(all([a1;a2;a5;a3;a4] == res));


%% Final results
disp("Everything ok!")
%% Testing int vector

assert(int_vector(1) == pi/12);
assert(all(int_vector(2) == pi * [1/3 3/2-1/4]));
assert(all(int_vector(3) == pi * [1/3 2 2*3/2-1/4]));
assert(all(int_vector(4) == pi * [1/3 2 4 3*3/2-1/4]));


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

