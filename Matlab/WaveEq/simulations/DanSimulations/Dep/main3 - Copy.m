
%Physical constants

R_f = 105; %(in mm)
Tm = 49.4;  %Linear tension of the material (in N / m = kg*m/(s2*m) = mg / ms^2)
rS1 = 3.18/2;
%rS2 = 4.76/2; %(both in mm)
mass = @(rS, rho) rho * (4*pi/3) * rS^3; % in mg
%rho1 = 7.93; %in g/cm3 = mg/mm^3
rho2 = 3.25; % also in mg/mm3
v0 = linspace(.50, 1.10, 7); % in  mm/ms = m/s
mu = 1.68e-2; %Density of membrane per unit of area (mg/mm^2) (Sara Wrap membrane)

for idx = 1:length(v0)
    v_k = v0(idx);
    mainFunction1_8(rS1, Tm, R_f/rS1, mu, mass(rS1, rho2), ...
            'v_k'     , -abs(v_k), ...
            'N'       , 150, ...
            'plotter' , false, ...
            'FileName', 'simulationDan.csv', ...
            'exportData', true ...
            );
end