%Plotter to see stored data

close all;
%[file, path] = uigetfile('*.*', 'Seleccionar el historial', 'simulations\');
file = 'PaperFigure5.csv';
path = 'D:\GITRepos\MyFiles\Matlab\WaveEq\AxisSymmetricv_1.8\simulations\';
if isequal(file, 0)
    return;
else
    conffigs = detectImportOptions(fullfile(path, file));
    conffigs.VariableTypes{1} = 'string';
    conffigs.PreserveVariableNames = true;
    %conffigs.SelectedVariableNames = {'ID', 'vi', 'surfaceTension', 'radius'};
    values = readtable(fullfile(path, file), conffigs);
end
%values = values(:, {'ID', 'surfaceTension', 'radius'});

%% Settings of radii to be plotted
symbol = {'o'; '>'; 's'; '>'; 'x'; '*'; '+'; '<'; 'v'; 'p'; '^'; 'p'; 'h'; 'v'; 'd'; '+'};

cats = {0.35; 0.5; 0.795; 0.85; 0.9; 0.95; 0.995; 1.15; 1.25; 1.35; 1.75; 2; 2.38; 2.78; 3; 3.175};
configs = struct('radius', cats, 'symbols', symbol);
LL = length(configs);


%% Coefficient of restitution
%PANEL (a)
figureCoefOfRestitution = figure(1);
set(gcf,'position',[100, 100, 560, 420], 'Units', 'pixels');

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
  'XTick'       , 0:0.25:2  , ...
  'LineWidth'   , 1         );
hold on; grid on;
xlim([-.01 1.35]);
ylim([0.3, 1.05]);
xlabel('$ V_{0} $', 'Interpreter', 'latex', 'FontSize', 24);
ylabel('$\alpha^{2} \ \ \ \ $', 'Interpreter', 'latex', 'Rotation', 0, ...
      'FontSize', 24);


for ii = 1:height(values)
    if values.radius(ii) < 0.7 %abs(values.radius(ii)-.995) > 0.01 %
        %continue;
    end
    load(fullfile("simulations", sprintf("simul%g_%g_%s.mat", values{ii, 'surfaceTension'}, ...
        values{ii, 'radius'}, values{ii, 'ID'})),...
        'coefOfRestitution', 'v_k', 'rS', 'Tm', 'mu');

    v_k = abs(v_k); 
    if v_k <0.1 || (ii >= 40 && abs(values.radius(ii) - 0.95) > 0.06)
        continue;
    end
%     fprintf("%d:  simul%g_%g_%s.mat, %f, %f\n", ii, values{ii, 'surfaceTension'}, ...
%         values{ii, 'radius'}, values{ii, 'ID'}, ...
%         v_k, coefOfRestitution);
    for jj = 1:length(cats)
        if abs(rS - cats{jj}) < 0.01
            break;
        end
    end
    %jj = mod(mod(ceil(1e+7 * rS), 2011), 10)+1; % le asignamos un marker al azar
   
    if ii < 40
        A = scatter(v_k, (coefOfRestitution), ...
            'filled', 'black');
        set(A                               , ...
            'LineWidth'       , 1.2         , ...
            'SizeData'        , 75         , ...
            'MarkerEdgeColor' , [.2 .2 .2]     , ...
            'MarkerFaceColor' , [.7 .7 .7] , ... %[.1+rS/3.5 .1+rS/3.5 .1+rS/3.5]     , ...
            'Marker'          , configs(jj).symbols ); 
    else
         A = scatter(v_k, (coefOfRestitution));
         set(A                               , ...
            'LineWidth'       , 1.2         , ...
            'SizeData'        , 75         , ...
            'MarkerEdgeColor' , [.2 .2 .2]     , ...
            'Marker'          , configs(jj).symbols );
    end
end

a = gca;
xx = a.XLim;
yy = a.YLim;
xrange = (xx(2) - xx(1))/10;
yrange = (yy(2) - yy(1))/10;
xx(1) = xx(1) - xrange;
xx(2) = xx(2) + xrange/5;
yy(1) = yy(1) - yrange;
yy(2) = yy(2) + yrange;
%a.XLim = xx;
a.YLim = yy;
%tt = text(.05, 2.75, '$a)$', 'Interpreter', 'latex', 'FontSize', 16);
print(figureCoefOfRestitution, '-depsc', '-r300', 'Graficos/coefOfRestitution.eps');

%PANEL (a)
figureSmallCoef = figure(2);
set(gcf,'position',[700, 100, 800, 420], 'Units', 'pixels');

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
  'LineWidth'   , 1         );
hold on; grid on;
%xlim([-.01 0.35]);
%ylim([0.3, 1.05]);
xlabel('$ V_{0} $', 'Interpreter', 'latex', 'FontSize', 24);
ylabel('$\alpha^{2} \ \ \ \ $', 'Interpreter', 'latex', 'Rotation', 0, ...
      'FontSize', 24);

for jj= 1:length(cats)
    subvalues = values(abs(values.radius - cats{jj}) < 0.05, :);
    A = zeros(height(subvalues), 1);
    for ii = 1:height(subvalues)
        load(fullfile("simulations", sprintf("simul%g_%g_%s.mat", values{ii, 'surfaceTension'}, ...
            values{ii, 'radius'}, values{ii, 'ID'})),...
            'coefOfRestitution', 'v_k', 'rS', 'Tm', 'mu');
        A(ii) = coefOfRestitution;
    end
    
    plot(abs(subvalues.vi), A);
end
for ii = 1:height(values)
    if values.radius(ii) < 0.7 %abs(values.radius(ii)-.995) > 0.01 %
        %continue;
    end
    load(fullfile("simulations", sprintf("simul%g_%g_%s.mat", values{ii, 'surfaceTension'}, ...
        values{ii, 'radius'}, values{ii, 'ID'})),...
        'coefOfRestitution', 'v_k', 'rS', 'Tm', 'mu');

    v_k = abs(v_k); 
    if v_k >0.15 || ii < 40
        continue;
    end
%     fprintf("%d:  simul%g_%g_%s.mat, %f, %f\n", ii, values{ii, 'surfaceTension'}, ...
%         values{ii, 'radius'}, values{ii, 'ID'}, ...
%         v_k, coefOfRestitution);
    for jj = 1:length(cats)
        if abs(rS - cats{jj}) < 0.01
            break;
        end
    end
    %jj = mod(mod(ceil(1e+7 * rS), 2011), 10)+1; % le asignamos un marker al azar
   
    if ii < 40
        A = scatter(v_k, (coefOfRestitution), ...
            'filled', 'black');
        set(A                               , ...
            'LineWidth'       , 1.2         , ...
            'SizeData'        , 75         , ...
            'MarkerEdgeColor' , [.2 .2 .2]     , ...
            'MarkerFaceColor' , [.7 .7 .7] , ... %[.1+rS/3.5 .1+rS/3.5 .1+rS/3.5]     , ...
            'Marker'          , configs(jj).symbols ); 
    else
         A = scatter(v_k, (coefOfRestitution));
         set(A                               , ...
            'LineWidth'       , 1.2         , ...
            'SizeData'        , 75         , ...
            'MarkerEdgeColor' , [.2 .2 .2]     , ...
            'Marker'          , configs(jj).symbols );
    end
end

a = gca;
xx = a.XLim;
yy = a.YLim;
xrange = (xx(2) - xx(1))/10;
yrange = (yy(2) - yy(1))/10;
xx(1) = xx(1) - xrange/2;
xx(2) = xx(2) + xrange/10;
yy(1) = yy(1) - yrange;
yy(2) = yy(2) + yrange;
a.XLim = xx;
a.YLim = yy;
%tt = text(.05, 2.75, '$a)$', 'Interpreter', 'latex', 'FontSize', 16);
print(figureCoefOfRestitution, '-depsc', '-r300', 'Graficos/coefOfRestitutionSmall.eps');
