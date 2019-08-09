function libsvm_size_acc(label_vector, instance_matrix,init_size,libsvm_type,option_string)
//Checks for the best trainingsize
// Calling Sequence
// libsvm_size_acc(label_vector, instance_matrix)
// libsvm_size_acc(label_vector, instance_matrix,init_size)
// libsvm_size_acc(label_vector, instance_matrix,init_size,libsvm_type)
// libsvm_size_acc(label_vector, instance_matrix,init_size,libsvm_type,option_string)
// Parameters
//
//      label_vector :
//      instance_matrix:
//      init_size: default=1000
//      libsvm_type: 'lin' for libsvm_lintrain or 'svm' for libsvm_svmtrain
//      option_string: option_string: additional parameters for svmtrain or lintrain
// Examples
//[label_vector, instance_matrix] = libsvmread(fullfile(libsvm_getpath(),"demos","heart_scale"));
// libsvm_size_acc(label_vector,instance_matrix,10,'svm');
// Authors
// Po-Wei Wang
// Holger Nahrstaedt
[nargout,nargin]=argn(0);

if (nargin<5) then
option_string = '';
end;

if (nargin<4) then
libsvm_type = 'lin';
end;
if (nargin<3) then
init_size = 1000;
end;

rand('seed', 0);

num_data = size(label_vector,1);

if num_data <= init_size
error('Data too small');
end

if sum(label_vector ~= floor(label_vector)) > 0
error('Not a classification problem');
end

if max(max(abs(instance_matrix))) > 1
warning('Warning: |instance_matrix|_1 > 1; you may scale data for faster training');
end

//perm_ind = randperm(num_data)';
perm_ind = grand(1, "prm", (1:num_data)')' ;

xt_perm = instance_matrix';
xt_perm = xt_perm(:,perm_ind);
y_perm = label_vector(perm_ind);

// draw a new figure
figure();
xlabel('Size of training subsets');
ylabel('Cross validation accuracy');
//set(gca(), 'xminortick', 'on')

subset_size = init_size;
sizes = []; cv_accs = [];
while 1,
  x_subset = xt_perm(:, 1:subset_size)';
  y_subset = y_perm(1:subset_size);
  if (libsvm_type=='lin') then
    cross_accuracy=libsvm_lintrain(y_subset, x_subset, option_string+' -v 5 -q');
  else
  cross_accuracy=libsvm_svmtrain(y_subset, x_subset, option_string+' -v 5 -q');
  end;
  cv_accs = [cv_accs; cross_accuracy(1)];
  sizes = [sizes; subset_size];
  plot2d(sizes, cv_accs,-1, logflag="ln");
  plot2d(sizes, cv_accs,6, logflag="ln");

  // set y-axis (accuracy) range at the first iteration
  if subset_size == init_size
    //set(gca, 'ylim', [min(cv_accs(1)-5,90), 100]);
    a=gca();
    a.data_bounds(:,2) = [min(cv_accs(1)-5,90), 100]';
  end

  if subset_size >= num_data
    break;
  else
    subset_size = min(2*subset_size, num_data);
  end
  //drawnow;
end

endfunction
