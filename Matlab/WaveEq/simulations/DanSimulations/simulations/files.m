
vals = readtable('simulationDan.csv', 'PreserveVariableNames', true);

vals{1, 'Density'} = 0;
for ii = 1:height(vals)
   name = sprintf('simul%g_%g_%s.mat', vals{ii, 'surfaceTension'}, vals{ii, 'radius'}, vals{ii, 'ID'}{1});
   load(name, 'mS');
   vals{ii, 'Density'} = mS;
end