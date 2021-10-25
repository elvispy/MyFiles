 %Physical constants

rS = 2; %Radius of the sphere (in mm)
R_f = 15;%52.4/2; %Number of raddi in half a length of the membrane (dimensionless)
Tm = 27;%11.6164; %Tension of the material (in mg / ms^2)
g = 9.80665e-3; %Gravity of earth (in mm/ms^2)
mu = 1.68e-2; %Density of membrane per unit of area (mg/mm^2) (Sara Wrap membrane)
mS = 7.8 * 4 * pi * (rS.^3) / 3; %Mass of the ball (in mg) (7.8 is the ball's 
%density in mg/mm^3)

%Units (Just for the record)
Lunit = rS; %Spatial unit of mesurement (in mm)
Vunit = sqrt(Tm/mu); %Velocity in mm/ms
Tunit = Lunit/Vunit; %Temporal unit of measurement (in ms)
Punit = mu * Lunit / Tunit^2; %Unit of pressure (in mg/ms^2)
