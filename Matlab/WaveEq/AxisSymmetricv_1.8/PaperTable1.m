%Plotter to see stored data
clearvars;
clc;

% FIle corresponding to the experimental contact time
[fileExp, pathExp] = uigetfile('*.*', 'Select One or More Files', 'datos_experimentales\');
if isequal(fileExp, 0)
    return;
else
    valuesExp = readtable(fullfile(pathExp, fileExp), 'PreserveVariableNames', true);
end

% File corresponding to numerical data with minimum tension
[fileMin, pathMin] = uigetfile('*.*', 'Select One or More Files', 'simulations\');
if isequal(fileMin, 0)
    return;
else
    valuesMin = readtable(fullfile(pathMin, fileMin), 'PreserveVariableNames', true);
end

% File corresponding to numerical data with MAXIMUM tension
[fileMax, pathMax] = uigetfile('*.*', 'Select One or More Files', 'simulations\');
if isequal(fileMax, 0)
    return;
else
    valuesMax = readtable(fullfile(pathMax, fileMax), 'PreserveVariableNames', true);
end

colsCTime = valuesMin.Properties.VariableNames([2 5]);

%% Settings of radii to be plotted
symbol = {'o'; '>'; 's'; '<'; '^'; 'p'; 'h'; 'v'; 'd'; '+'};

cats = {0.35; 0.5; 0.795; 1.25; 1.75; 2; 2.38; 2.78; 3; 3.175};
configs = struct('radius', cats, 'symbols', symbol);
LL = length(configs);


%% DATA


mu = 0.0168;
mS = @(rS) 7.8 * 4 * pi * (rS.^3) / 3;
M = @(rS) mu * rS^2 / mS(rS);
format short;
for ii = 1:LL
    
    expAuxTable = valuesExp(abs(valuesExp.radius - configs(ii).radius) < 0.1, :);
    if isempty(expAuxTable) == 1
        continue;
    end
    expAuxTable = sortrows(expAuxTable, {'vi'});
    minAuxTable = valuesMin(abs(valuesMin.radius - configs(ii).radius) < 0.1, :);   
    minAuxTable.vi = abs(minAuxTable.vi);
    minAuxTable = sortrows(minAuxTable, {'vi'});
    maxAuxTable = valuesMax(abs(valuesMax.radius - configs(ii).radius) < 0.1, :);
    maxAuxTable.vi = abs(maxAuxTable.vi);
    maxAuxTable = sortrows(maxAuxTable, {'vi'});  
    
    assert(max(max(expAuxTable.vi - minAuxTable.vi), max(expAuxTable.vi - maxAuxTable.vi)) < 0.05);
    
    fprintf('M: %0.4e \n', M(configs(ii).radius));
    mincTimeErrors = 100 * abs(minAuxTable.cTime - expAuxTable.cTime) ./ (expAuxTable.cTime);
    maxcTimeErrors = 100 * abs(maxAuxTable.cTime - expAuxTable.cTime) ./ (expAuxTable.cTime);
    fprintf("Maximum relative error in Contact Time: %0.5g \n", max(max(mincTimeErrors), max(maxcTimeErrors)));
    
    minMaxDefErrors = 100 * abs(minAuxTable.maxDeflection - expAuxTable.maxDeflection) ./ (expAuxTable.maxDeflection);
    maxmaxDefErrors = 100 * abs(maxAuxTable.maxDeflection - expAuxTable.maxDeflection) ./ (expAuxTable.maxDeflection);
    fprintf("Maximum relative error in Maximum Deflection: %0.5g \n", max(max(minMaxDefErrors), max(maxmaxDefErrors)));
    
    disp("-----------------------");
    
    
end
%% MAXIMUM DEFLECTION







