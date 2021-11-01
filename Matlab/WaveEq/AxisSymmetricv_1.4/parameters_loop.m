radii = [0.35, 0.795, 1.25, 1.75, 2.78, 3.175];
for iii = 1:length(radii)
    rS = radii(iii); %Radius of the sphere (in mm)
    
    for vi = 0.4:0.3:1
        clearvars -except vi rS radii;
        %Physical constants
        R_f = 52.4/rS; %Number of raddi in half a length of the membrane (dimensionless)
        Tm = 72; %11.6164; %Tension of the material (in mg / ms^2)
        g = 9.80665e-3; %Gravity of earth (in mm/ms^2)
        mu = 1.68e-2; %Density of membrane per unit of area (mg/mm^2) (Sara Wrap membrane)
        mS = 7.8 * 4 * pi * (rS.^3) / 3; %Mass of the ball (in mg) (7.8 is the ball's 
        %density in mg/mm^3)

        %Some initial conditions to loop through
        z_k = 1; %Current position of the center of the ball (Dimensionless)

        %-sqrt(vi^2 - 2*(z_k*rS - rS)*g)/sqrt(Tm/mu); %Current velocity of the ball (dimensionless)
        plotter = false;
        name = sprintf('simulations/historialTm%g.csv', Tm);
        main

    end
end