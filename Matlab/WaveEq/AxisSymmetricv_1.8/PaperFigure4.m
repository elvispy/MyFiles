%radii = [0.795, 1.25, 1.75, 2.78, 3.175];
try
    experimentalData = readtable([pwd, '/datos_experimentales/experimentalCourbin.csv'], 'PreserveVariableNames', true);
catch
    warning('No se han encontrados los datos experimentales.');
    return;
end



 for iii = 1:size(experimentalData, 1)
    rS = experimentalData{iii, 'radius'}; %Radius of the sphere (in mm)
    vi = experimentalData{iii, 'vi'};
    
    %Physical constants
    Tm = 27.001; %11.6164; %Tension of the material (in mg / ms^2)
    name = sprintf('historialExperimentalTm%g.csv', Tm);
    mainFunction1_8(rS, Tm, ...
        'v_k'     , -abs(vi), ...
        'RecordedTime', 0.005, ...
        'plotter' , true, ...
        'FileName', name, ...
        'exportData', true ...
        );
end