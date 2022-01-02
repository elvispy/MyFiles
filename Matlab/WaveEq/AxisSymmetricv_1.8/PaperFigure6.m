% This script will summarize relevant information about pressure at contact
% points in the kinematic match.

close all; clearvars;
snapshots = 10; plot_video = false;

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



