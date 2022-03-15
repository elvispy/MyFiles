
%Physical constants

R_f = 105/2; % Membrane RADIUS (in mm)
highTension = 107+8;  %Linear tension of the material (in N / m = kg*m/(s2*m) = mg / ms^2)
lowTension = 107-8;
rS = 4.76/2; %(both in mm)
mass = @(rS, rho) rho * (4*pi/3) * rS^3; % in mg
rho = 3.25; %in g/cm3 = mg/mm^3
%v0 = [0.5945; 0.6885; 0.7748; 0.8154; 0.8822; 0.8915; 0.9347]; % in  mm/ms = m/s
mu = 0.3; %Density of membrane per unit of area (mg/mm^2) (Sara Wrap membrane)

for v_k = .3:.05:.8
    %cd ..
    %HIGH TENSION
    solveMotion1_8(rS, highTension, R_f/rS, mu, mass(rS, rho), ...
        'v_k'     , -abs(v_k), ...
        'N'       , 200, ...
        'plotter' , false, ...
        'FileName', 'KM_vacuum_highTension.csv', ...
        'exportData', true ...
        );
    % LOW TENSION
    solveMotion1_8(rS, lowTension, R_f/rS, mu, mass(rS, rho), ...
        'v_k'     , -abs(v_k), ...
        'N'       , 200, ...
        'plotter' , false, ...
        'FileName', 'KM_vacuum_lowTension.csv', ...
        'exportData', true ...
        );
    
    % MEDIUM TENSION
    solveMotion1_8(rS, (highTension + lowTension)/2, R_f/rS, mu, mass(rS, rho), ...
        'v_k'     , -abs(v_k), ...
        'N'       , 200, ...
        'plotter' , false, ...
        'FileName', 'KM_vacuum_mediumTension.csv', ...
        'exportData', true ...
        );
    %cd DanSimulations\
end