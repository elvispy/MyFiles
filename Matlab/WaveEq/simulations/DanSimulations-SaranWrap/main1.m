
%Physical constants

R_f = 105/2; % Membrane RADIUS (in mm)
Tm = 49.4;  %Linear tension of the material (in N / m = kg*m/(s2*m) = mg / ms^2)
rS = 3.18/2;
mass = @(rS, rho) rho * (4*pi/3) * rS^3; % in mg
rho = 7.93; %in g/cm3 = mg/mm^3
v0 = [0.6372; 0.7229; 0.7884; 0.8265; 0.8891; 0.9309; 1.01]; % in  mm/ms = m/s
mu = 1.46e-2; %Density of membrane per unit of area (mg/mm^2) (Sara Wrap membrane)

for idx = 1:length(v0)
    v_k = v0(idx);
    solveMotion1_9(rS, Tm, R_f/rS, mu, mass(rS, rho), ...
            'v_k'     , -abs(v_k), ...
            'N'       , 150, ...
            'plotter' , false, ...
            'FileName', 'simulationDan_air_Saran.csv', ...
            'exportData', true ...
            );
end
