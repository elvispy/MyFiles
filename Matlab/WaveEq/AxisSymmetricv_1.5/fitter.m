
%FITTER. This script will try to fit the best value for Tm
clear variables;
g = 9.80665e-3; %Gravity of earth (in mm/ms^2)
mu = 1.68e-2; %Density of membrane per unit of area (mg/mm^2) (Sara Wrap membrane)

%density in mg/mm^3)

Tm = 62;
Tmax = 72;
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
 
        mainFunction(rS, Tm, 'v_k', vi, 'plotter', true);
            

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