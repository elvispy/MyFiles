%Plotter to see stored data

close all;

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


%% CONTACT TIME

figurectime = figure(1);
set(gcf,'position',[100, 100, 560, 420], 'Units', 'pixels');    

% NUMERICAL DATA, MAXIMUM TENSION
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
  'XTick'       , -0.2:0.2:2, ...
  'LineWidth'   , 1         );
hold on; grid on;
xlim([0, 1.35]);
xlabel('$V_{0}$', 'Interpreter', 'latex', 'FontSize', 24);
ylabel('$t_{c} \ \ \ $', 'Interpreter', 'latex', 'Rotation', 0, ...
      'FontSize', 24);
ylim([-1.5, 20]);

% if showboth == true
%     F  = cell(LL + 3, 1);
%     F{1} = 'T \approx 7.3 MPa ';
%     F{2} = 'T \approx 2.2 MPa ';
%     F{3} = 'Datos experimentales';
% else
%     F = cell(LL + 2, 1);
%     if join == true
%         F{1} = 'Datos numéricos';
%         F{2} = 'Datos experimentales';
%     end
% end
FExp = cell(LL+3, 1);
FMin = cell(LL+3, 1);
FMax = cell(LL+3, 1);


for ii = 1:LL
    auxtbl = valuesExp(abs(valuesExp.radius - configs(ii).radius) < 0.1, :);
    auxtbl = auxtbl(:, colsCTime);
    if isempty(auxtbl) == 0
        FExp{ii+3} = scatter(abs(auxtbl{:, colsCTime(1)}), auxtbl{:, colsCTime(2)}, ...
            'filled', 'black');   
        set(FExp{ii+3}                           , ...
            'LineWidth'       , 1.2         , ...
            'SizeData'        , 20         , ...
            'MarkerEdgeColor' , 'black'     , ...
            'MarkerFaceColor' , 'black'     , ...
            'DisplayName'     , sprintf('R = %6.3g mm', configs(ii).radius) , ...
            'Marker'          , configs(ii).symbols );        
        FExp{ii+3} = [];%F{ii+3}.DisplayName;
    end

    
    auxtbl = valuesMin(abs(valuesMin.radius - configs(ii).radius) < 0.1, :);
    auxtbl = auxtbl(:, colsCTime);
    if isempty(auxtbl) == 0
        FMin{ii+3} = scatter(abs(auxtbl{:, colsCTime(1)}), auxtbl{:, colsCTime(2)});   
        set(FMin{ii+3}                      , ...
            'LineWidth'       , 1.2         , ...
            'SizeData'        , 100         , ...
            'MarkerEdgeColor' , [.6 .6 .6]  , ...
            'DisplayName'     , sprintf('R = %6.3g mm', configs(ii).radius) , ...
            'Marker'          , configs(ii).symbols );        
        FMin{ii+3} = [];%F{ii+3}.DisplayName;
     
        Tm = valuesMin.surfaceTension(1);

    end

    
    auxtbl = valuesMax(abs(valuesMax.radius - configs(ii).radius) < 0.1, :);
    auxtbl = auxtbl(:, colsCTime);
    if isempty(auxtbl) == 0
        FMax{ii+3} = scatter(abs(auxtbl{:, colsCTime(1)}), auxtbl{:, colsCTime(2)});   
        set(FMax{ii+3}                      , ...
            'LineWidth'       , 1.2         , ...
            'SizeData'        , 100         , ...
            'MarkerEdgeColor' , 'black'     , ...
            'DisplayName'     , sprintf('R = %6.3g mm', configs(ii).radius) , ...
            'Marker'          , configs(ii).symbols );        
        FMax{ii+3} = [];%F{ii+3}.DisplayName;
    end
end

mu = 1.68e-2; %Density of membrane per unit of area (mg/mm^2) (Sara Wrap membrane)
Vunit = sqrt(Tm/mu);
D = 52.4;%/configs(ii).radius;
line([0.05, 1.25], [2*D/Vunit, 2*D/Vunit], 'Marker', configs(ii).symbols,  ...
    'MarkerSize', 12, 'Color', 'r');
%tt = text(.05, 16.75, '$a)$', 'Interpreter', 'latex', 'FontSize', 16);
%print(figurectime, '-depsc', '-r300', 'Graficos/cTimevsCourbinHypothesis.eps');
% %% MAXIMUM DEFLECTION
% 
% 
% colsmaxDef = valuesMin.Properties.VariableNames([2 6]);
% 
% figureDef = figure(2);
% set(gcf,'position',[700, 100, 560, 420], 'Units', 'pixels');
% 
% set(gca, ...
%   'Box'         , 'on'      , ...
%   'FontSize'    , 16        , ...
%   'TickDir'     , 'in'      , ...
%   'TickLength'  , [.02 .02] , ...
%   'XMinorTick'  , 'on'      , ...
%   'YMinorTick'  , 'on'      , ...
%   'YGrid'       , 'on'      , ...
%   'XColor'      , [.3 .3 .3], ...
%   'YColor'      , [.3 .3 .3], ...
%   'LineWidth'   , 1         );
% hold on; grid on;
% xlim([0, 1.35]);
% xlabel('$V_{0}$', 'Interpreter', 'latex', 'FontSize', 24);
% ylabel('$\delta \ \ $', 'Interpreter', 'latex', 'Rotation', 0, ...
%       'FontSize', 24);
% ylim([-0.4, 6.5]);
% FExp = cell(LL+3, 1);
% FMin = cell(LL+3, 1);
% FMax = cell(LL+3, 1);
% 
% 
%   
% for ii = 1:LL
%     
%     auxtbl = valuesExp(abs(valuesExp.radius - configs(ii).radius) < 0.1, :);
%     auxtbl = auxtbl(:, colsmaxDef);
%     if isempty(auxtbl) == 0
%         FExp{ii+3} = scatter(abs(auxtbl{:, colsmaxDef(1)}), ...
%             auxtbl{:, colsmaxDef(2)}, 'filled', 'black');   
%         set(FExp{ii+3}                           , ...
%             'LineWidth'       , 1.2         , ...
%             'SizeData'        , 20         , ...
%             'MarkerEdgeColor' , 'black'     , ...
%             'MarkerFaceColor' , 'black'     , ...
%             'DisplayName'     , sprintf('R = %6.3g mm', configs(ii).radius) , ...
%             'Marker'          , configs(ii).symbols );        
%         FExp{ii+3} = [];%F{ii+3}.DisplayName;
%     end
% 
%     
%     auxtbl = valuesMin(abs(valuesMin.radius - configs(ii).radius) < 0.1, :);
%     auxtbl = auxtbl(:, colsmaxDef);
%     if isempty(auxtbl) == 0
%         FMin{ii+3} = scatter(abs(auxtbl{:, colsmaxDef(1)}), ...
%             auxtbl{:, colsmaxDef(2)});   
%         set(FMin{ii+3}                      , ...
%             'LineWidth'       , 1.2         , ...
%             'SizeData'        , 100          , ...
%             'MarkerEdgeColor' , [.6 .6 .6]  , ...
%             'DisplayName'     , sprintf('R = %6.3g mm', configs(ii).radius) , ...
%             'Marker'          , configs(ii).symbols );        
%         FMin{ii+3} = [];%F{ii+3}.DisplayName;
%     end
% 
%     
%     auxtbl = valuesMax(abs(valuesMax.radius - configs(ii).radius) < 0.1, :);
%     auxtbl = auxtbl(:, colsmaxDef);
%     if isempty(auxtbl) == 0
%         FMax{ii+3} = scatter(abs(auxtbl{:, colsmaxDef(1)}), ...
%             auxtbl{:, colsmaxDef(2)});   
%         set(FMax{ii+3}                      , ...
%             'LineWidth'       , 1.2         , ...
%             'SizeData'        , 100         , ...
%             'MarkerEdgeColor' , 'black'     , ...
%             'DisplayName'     , sprintf('R = %6.3g mm', configs(ii).radius) , ...
%             'Marker'          , configs(ii).symbols );        
%         FMax{ii+3} = [];%F{ii+3}.DisplayName;
%     end
% 
% end
% tt = text(.06, 5.5, '$b)$', 'Interpreter', 'latex', 'FontSize', 16);
% print(figureDef, '-depsc', '-r300', 'Graficos/maxDefvsCourbinnew.eps');
% 







