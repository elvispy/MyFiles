%radii = [0.795, 1.25, 1.75, 2.78, 3.175];
try
    cTimes = readtable([pwd, '/datos_experimentales/cTimeExp.csv'], 'PreserveVariableNames', true);
    maxDefs = readtable([pwd, '/datos_experimentales/maxDefExp.csv'], 'PreserveVariableNames', true);
catch
    warning('No se han encontrados los datos experimentales.');
    return;
end

for iii = 170:size(cTimes, 1)
    rS = cTimes{iii, 'radius'}; %Radius of the sphere (in mm)
    vi = cTimes{iii, 'vi'};
    
    %Physical constants
    Tm = 22; %11.6164; %Tension of the material (in mg / ms^2)

    name = sprintf('historialExperimentalTm%g.csv', Tm);
    mainFunction1_6(rS, Tm, ...
        'v_k'     , -abs(vi), ...
        'RecordedTime', 0.04, ...
        'plotter' , false, ...
        'FileName', name, ...
        'exportData', true ...
        );
end

for iii = 1:size(maxDefs, 1)
    rS = maxDefs{iii, 'radius'}; %Radius of the sphere (in mm)
    vi = maxDefs{iii, 'vi'};
    
    %Physical constants
    Tm = 23; %11.6164; %Tension of the material (in mg / ms^2)
    name = sprintf('historialExperimentalTm%g.csv', Tm);
    mainFunction1_6(rS, Tm, ...
        'v_k'     , -abs(vi), ...
        'plotter' , false, ...
        'FileName', name, ...
        'exportData', true ...
        );
end