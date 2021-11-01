
%FITTER. This script will try to fit the best value for Tm
clear variables;
g = 9.80665e-3; %Gravity of earth (in mm/ms^2)
mu = 1.68e-2; %Density of membrane per unit of area (mg/mm^2) (Sara Wrap membrane)

%density in mg/mm^3)

Tm = 65;
Tmax = 75;
dTm = 1;

data = {[0.68, -0.4776, 0.35]; [5.08, -0.644, 1.75]; ...
    [8.56, -0.5582, 2.78]};
maxError = 1e+6;
bestPredictor = [];
bestTm = 0;
while Tm < Tmax
    fprintf('Im in %.1f \n', Tm);
    
    predictor = [0, 0, 0];
    error = 0;
    for jj = 1:length(data)
        vi = data{jj}(2);
        rS = data{jj}(3);
        R_f = 52.4/rS; %Number of raddi in half a length of the membrane (dimensionless)
        mS = 7.8 * 4 * pi * (rS.^3) / 3; %Mass of the ball (in mg) (7.8 is the ball's      
        
        %Units (Just for the record)
        Lunit = rS; %Spatial unit of mesurement (in mm)
        Vunit = sqrt(Tm/mu); %Velocity in mm/ms
        Tunit = Lunit/Vunit; %Temporal unit of measurement (in ms)
        Punit = mu * Lunit / Tunit^2; %Unit of pressure (in mg/ms^2)
        
        %z_k = 1;%(Lunit + 0.1)/Lunit; %Current position of the center of the ball (Dimensionless)
        clear z_k;
        v_k = -vi/Vunit;% -sqrt(vi^2 - 2*(z_k*Lunit - Lunit)*g)/Vunit; %Current velocity of the ball (dimensionless)
        plotter = false;
        main
        
        values = readtable([pwd, '/simulations/historial.csv'], 'PreserveVariableNames', true);
        ext = values{size(values, 1), 'cTime'};
        error = error + (ext - data{jj}(1))^2;
        predictor(jj) = ext;   
    end
    
    if error < maxError
        maxError = error;
        bestPredictor = predictor;
        bestTm = Tm;
    end
    
    Tm = Tm + dTm;
end