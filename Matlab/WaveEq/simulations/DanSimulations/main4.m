
%Physical constants

R_f = 105; %(in mm)
Tm = 49.4;  %Linear tension of the material (in N / m = kg*m/(s2*m) = mg / ms^2)
rS = 4.76/2; %(both in mm)
mass = @(rS, rho) rho * (4*pi/3) * rS^3; % in mg
rho = 3.25; % also in mg/mm3
v0 = [0.6108; 0.6662; 0.7376; 0.8143; 0.8583; 0.8969; 0.9731]; % in  mm/ms = m/s
mu = 1.68e-2; %Density of membrane per unit of area (mg/mm^2) (Sara Wrap membrane)

for idx = 1:length(v0)
    v_k = v0(idx);
    mainFunction1_8(rS, Tm, R_f/rS, mu, mass(rS, rho), ...
            'v_k'     , -abs(v_k), ...
            'N'       , 25, ...
            'plotter' , false, ...
            'FileName', 'simulationDan_exact.csv', ...
            'exportData', true ...
            );
end