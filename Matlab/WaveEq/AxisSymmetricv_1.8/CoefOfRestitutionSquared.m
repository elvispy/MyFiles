close all; clearvars;

%% Reading the file to be analyzed
[file, path] = uigetfile('*.*', 'Select a File', ...
    'simulations\');

values = readtable(fullfile(path, file), 'PreserveVariableNames', true);
g = 9.80665e-3; % Gravity

for ii = 1:height(values)
    
    name = sprintf('simulations\\simul%.3g_%.3g_%g.mat', values{ii, 'surfaceTension'}, ...
        values{ii, 'radius'}, values{ii, 'ID'}); 
    disp(name);
    try
        var = load(name); % Cargamos los datos ya calculados
    catch
        continue;
    end
    mS = 7.8 * 4 * pi * (var.rS.^3) / 3;
    Em_in = 1/2 * mS * (values{ii, 'vi'}^2);
    zeroPotential = var.recordedEta(1, 1) + values{ii, 'radius'};
    
    [mii, mcPoints] = size(var.recordedPk);
    vk = (var.recordedz_k(mii) - var.recordedz_k(mii - 2))/(var.recordedTimes(mii) - var.recordedTimes(mii-2)); 
    Em_out = 1/2 * mS * vk^2 + mS * g * (var.recordedz_k(mii - 1) - zeroPotential);
    
    COR = Em_out/Em_in;
    coefOfRestitution = COR;
    
    save(name, 'COR', 'coefOfRestitution', '-append');
    
end