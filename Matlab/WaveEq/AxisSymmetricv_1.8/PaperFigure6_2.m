

close all; clearvars;

 %Physical constants
clear variables;
rS = 0.795; %Radius of the sphere (in mm)
%R_f = 7.95/rS; %Number of raddi in half a length of the membrane (dimensionless)
Tm = 27;%50.6164; %Tension of the material (in mg / ms^2)
g = 9.80665e-3; %Gravity of earth (in mm/ms^2)
%mu = 1.68e-2; %Density of membrane per unit of area (mg/mm^2) (Sara Wrap membrane)
%mS = 73.8 * 4 * pi * (rS.^3) / 3;%7.8 * 4 * pi * (rS.^3) / 3; %Mass of the ball (in mg) (7.8 is the ball's 
%density in mg/mm^3)

% mainFunction1_8(rS, Tm, ...
%     'v_k', -1.20645, ...
%     'plotter', true, ...
%     'RecordedTime', 0.001, ...
%     'FileName', 'historialPlot.csv', ...
%     'method', 'Euler', ...
%     'exportData', true, ...
%     'saveAfterContactEnded', false);


%% Reading the file to be analyzed
% As of 25/12, we are using simul27_0.795_1214 as an exmple
[file, path] = uigetfile('*.mat', 'Select a File', ...
    'simulations\');
load(fullfile(path, file), 'recordedPk', 'recordedTimes', 'rt', 'N', 'rS','Tm', 'mu');

%recordedPk = recordedPk(1:2250, :);
[mii, Ntot] = size(recordedPk);
Tunit = rS/sqrt(Tm/mu);
recordedTimes = recordedTimes/Tunit;
rt = rt/Tunit; % Dimensionless recorded time
Punit = Tm/rS;
recordedPk = recordedPk/Punit;

xAxis = linspace(0, 1, Ntot); YtickMax = (12/10) * max(recordedPk(:));

%% Plotting contact area

area = figure();
%title('Área presionada en función del tiempo', ...
%        'FontSize', 14, 'FontName', 'Cambria');

set(gca, ...
  'Box'         , 'on'      , ...
  'FontSize'    , 16        , ...
  'TickDir'     , 'in'      , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'YGrid'       , 'on'      , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.3 .3 .3], ...
  'LineWidth'   , 1         , ...
  'XTick'       , 0:20:mii*rt);
hold on;


figure(area); grid on; hold on;
carea = zeros(mii, 1);
for ii = 1:mii
    carea(ii) = length(recordedPk(ii, abs(recordedPk(ii, :)) > 0.0001)) / Ntot;
end

plot(recordedTimes, carea, ...
    'LineWidth'   , 2, ...
    'Color'       , 'k'); 

xlim([-0.55, recordedTimes(end)]);
xlabel('$tC/R$', 'FontSize', 20, 'Interpreter', 'latex');
ylh = ylabel(gca, '$\frac{r_{c}}{R} $', 'FontSize', 24, ...
    'Rotation', 0, 'Interpreter', 'latex');
dy = 4.5;
ylh.Position(1) = ylh.Position(1) - dy;
a = gca;
a.Position(1) = a.Position(1) * 15/10;

print(area, '-depsc', '-r300', 'Graficos/contactArea.eps');



