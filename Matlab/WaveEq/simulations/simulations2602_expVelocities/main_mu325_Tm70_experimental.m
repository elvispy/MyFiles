
%Physical constants

R_f = 105/2; % Membrane RADIUS (in mm)
Tm = 70;  %Linear tension of the material (in N / m = kg*m/(s2*m) = mg / ms^2)
rS = 4.76/2; %(both in mm)
mass = @(rS, rho) rho * (4*pi/3) * rS^3; % in mg
rho = 3.25; %in g/cm3 = mg/mm^3
v0 = [0.472; 0.4872; 0.5685; 0.6331;  0.6799; 0.7411]; % in  mm/ms = m/s
mu = 0.3; %Density of membrane per unit of area (mg/mm^2) (Sara Wrap membrane)

for ii = 1:length(v0)
    v_k = v0(ii);
    %HIGH TENSION
    solveMotion1_8(rS, Tm, R_f/rS, mu, mass(rS, rho), ...
        'v_k'     , -abs(v_k), ...
        'N'       , 200, ...
        'plotter' , false, ...
        'FileName', 'KM_vacuum_Tm70_experimental.csv', ...
        'exportData', true ...
        );
%     % LOW TENSION
%     solveMotion1_8(rS, lowTension, R_f/rS, mu, mass(rS, rho), ...
%         'v_k'     , -abs(v_k), ...
%         'N'       , 200, ...
%         'plotter' , false, ...
%         'FileName', 'KM_vacuum_lowTension.csv', ...
%         'exportData', true ...
%         );
%     
%     % MEDIUM TENSION
%     solveMotion1_8(rS, (highTension + lowTension)/2, R_f/rS, mu, mass(rS, rho), ...
%         'v_k'     , -abs(v_k), ...
%         'N'       , 200, ...
%         'plotter' , false, ...
%         'FileName', 'KM_vacuum_mediumTension.csv', ...
%         'exportData', true ...
%         );
    %cd DanSimulations\
end