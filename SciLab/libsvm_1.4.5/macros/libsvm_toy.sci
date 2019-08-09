function libsvm_toy(label_vector, instance_matrix, options, contour_level)
// shows the two-class classification boundary of the 2-D data
// Calling Sequence
// libsvm_toy(label_vector, instance_matrix, options, contour_level)
// Parameters
// label_vector: N by 1, has to be two-class
// instance_matrix: N by 2
// options: default '',  see svmtrain, has to be a classification formulation (e.g."-c 1000 -g 0.5") .
// contour_level: default [0 0],    change to [-1 0 1] for showing the +/- 1 margin.
// Description
// libsvm_toy shows the two-class classification boundary of the 2-D data
// Examples
// instance_matrix = [rand(20,2); -1*rand(20,2)];
// label_vector=[zeros(20,1);ones(20,1)];
// libsvm_toy(label_vector, instance_matrix)
// 
// libsvm_toy(label_vector, instance_matrix,"-c 1000 -g 0.5",[-1 0 1])
// 
// 
// Authors
// Holger Nahrstaedt
// Hsuan-Tien Lin, htlin at caltech.edu, 2006/04/07

 [nargout,nargin]=argn(0);

if nargin <= 1
  instance_matrix = [];
elseif nargin == 2    
  options = ''
end

if nargin <= 3
  contour_level = [0 0];
end

N = size(label_vector, 1);
if N <= 0
  error( 'number of data should be positive\n');
end

if size(label_vector, 2) ~= 1
  error( 'the label matrix should have only one column\n');
end

if size(instance_matrix, 1) ~= N
  error('the label and instance matrices should have the same number of rows\n');
  return;
end

if size(instance_matrix, 2) ~= 2
  error('svmtoy only works for 2-D data\n');
end

mdl = libsvm_svmtrain(label_vector, instance_matrix, options);

nclass = mdl.nr_class;
svmtype = mdl.Parameters(1);

if nclass ~= 2 | svmtype >= 2
  error('cannot plot the decision boundary for these SVM problems\n');
end

minX = min(instance_matrix(:, 1));
maxX = max(instance_matrix(:, 1));
minY = min(instance_matrix(:, 2));
maxY = max(instance_matrix(:, 2));

gridX = (maxX - minX) ./ 100;
gridY = (maxY - minY) ./ 100;

minX = minX - 10 * gridX;
maxX = maxX + 10 * gridX;
minY = minY - 10 * gridY;
maxY = maxY + 10 * gridY;

[bigX, bigY] = meshgrid(minX:gridX:maxX, minY:gridY:maxY);

mdl.Parameters(1) = 3; // the trick to get the decision values
ntest=size(bigX, 1) * size(bigX, 2);
instance_test=[matrix(bigX, ntest, 1), matrix(bigY, ntest, 1)];
label_test = zeros(size(instance_test, 1), 1);

[Z, acc] = libsvm_svmpredict(label_test, instance_test, mdl);

bigZ = matrix(Z, size(bigX, 1), size(bigX, 2));

clf();


ispos = (label_vector == label_vector(1));
pos = find(ispos);
neg = find(~ispos);

plot(instance_matrix(pos, 1), instance_matrix(pos, 2), 'o');
plot(instance_matrix(neg, 1), instance_matrix(neg, 2), 'x');

//contour(bigX, bigY, bigZ, contour_level);
contour2d(minX:gridX:maxX, minY:gridY:maxY, bigZ, contour_level);

title(options);

endfunction