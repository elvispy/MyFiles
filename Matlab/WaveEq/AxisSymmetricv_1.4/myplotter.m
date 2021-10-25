%Plotter to see stored data
%%%
join = true;
%%%
close;
values = readtable('historialTm72.csv', 'PreserveVariableNames', true);

symbol = ["o", "o", "s", "s", "^", "p" "^", "x", "d", "+"];
fsymbol = ["filled", "MarkerEdgeColor", "MarkerEdgeColor", ...
    "MarkerEdgeColor", "filled", "MarkerEdgeColor","MarkerEdgeColor", ...
    "MarkerEdgeColor", "filled", "MarkerEdgeColor"];
cats = [0 0.4 0.51 0.8 1.3 1.8 2.05 2.4 2.8 3.1 3.2];

binnedRadius = discretize(values.("radius"), cats, 'categorical', symbol);

values.marker = binnedRadius;
cols = values.Properties.VariableNames([2 3 4]);

%% Plot settings
if join == true
    tiledlayout(2, 1);
    set(gcf,'position',[500,5,500,750]);
    nexttile;
    title('Datos obtenidos por el método vs experimentales');
else
    tiledlayout(2, 2);
    set(gcf,'position',[300,5,1000,750]);
    nexttile;
    title('Datos obtenidos por el método');
end
   
hold on;
xlim([0, 1.5]);
xlabel('Velocidad inicial (m/s)');
ylim([0, 20]);
ylabel('Tiempo de contacto (ms)');

for ii = 1:length(symbol)
    auxtbl = values(values.marker == symbol(ii), :);
    auxtbl = auxtbl(:, cols);
    
    scatter(-auxtbl{:, cols(3)}, auxtbl{:, cols(1)}, 40, ...
        symbol(ii), fsymbol(ii), 'b');
end

if join == false
    nexttile;
    title('Datos experimentales');
end
expCtime = readtable('cTimeExp.csv', 'PreserveVariableNames', true);
binnedCtime = discretize(expCtime.("radius"), cats, 'categorical', symbol);
expCtime.marker = binnedCtime;
cols = expCtime.Properties.VariableNames;

%First, contact time
hold on;
xlim([0, 1.5]);
xlabel('Velocidad inicial (m/s)');
ylim([0, 20]);
ylabel('Tiempo de contacto (ms)');

for ii = 1:length(symbol)
    auxtbl = expCtime(expCtime.marker == symbol(ii), :);
    auxtbl = auxtbl(:, cols);
    scatter(auxtbl{:, cols(2)}, auxtbl{:, cols(1)}, 50, ...
        symbol(ii), fsymbol(ii), 'black');
end


nexttile;
cols = values.Properties.VariableNames([2 3 4]);
title('Datos obtenidos por el método');
hold on;
xlim([0, 1.5]);
xlabel('Velocidad inicial (m/s)');
ylim([0, 6.5]);
ylabel('Maximum Deflection (mm)');
for ii = 1:length(symbol)
    auxtbl = values(values.marker == symbol(ii), :);
    auxtbl = auxtbl(:, cols);
    scatter(-auxtbl{:, cols(3)}, auxtbl{:, cols(2)}, 40, ...
        symbol(ii), fsymbol(ii), 'b');
end


%% NOW EXPERIMENTAL DATA

%Maximum Deflection

expmDef = readtable('maxDefExp.csv', 'PreserveVariableNames', true);
binnedmDef = discretize(expmDef.("radius"), cats, 'categorical', symbol);
expmDef.marker = binnedmDef;
cols = expmDef.Properties.VariableNames;


%Now Maximum Deflection
if join == false
    nexttile;
    title('Datos experimentales');
end
hold on;
xlim([0, 1.5]);
xlabel('Velocidad inicial (m/s)');
ylim([0, 6.5]);
ylabel('Maximum deflection (mm)');

for ii = 1:length(symbol)
    auxtbl = expmDef(expmDef.marker == symbol(ii), :);
    auxtbl = auxtbl(:, cols);
    scatter(auxtbl{:, cols(2)}, auxtbl{:, cols(1)}, 50, ...
        symbol(ii), fsymbol(ii), 'black');
end









