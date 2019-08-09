function [scaled_instance,scaled_parameters,scaled_label,scaled_label_parameters] = libsvm_normalize(instance,x,label,y)
//scale the input data for correct learning
// Calling Sequence
//   [scaled_instance,scaled_parameters] = libsvm_normalize(instance);
//   [scaled_instance,scaled_parameters] = libsvm_normalize(instance,[meanV,stdV]);
//
//   [scaled_instance] = libsvm_normalize(instance,scaled_parameters);
//   
//  [scaled_instance,scaled_parameters,scaled_label,scaled_label_parameters] = libsvm_normalize(instance,[meanV,stdV],label,[label_mean, label_std]);
//  Description
//  Scaling before applying SVM is very important in order to avoid several  numerical problems! 
//  Each feature row in the instance matrix has be scaled indepented from the other features.
//  
//  It is important to scale the testing data with the same scale as the training data!
//   Scale your data. For example, scale each attribute to a mean of 0 and a standard deviation of 1.
//  Examples
//  [label,instance]=libsvmread(fullfile(libsvm_getpath(),"demos","heart_scale"));
//  [scaled_instance,scaled_parameters] = libsvm_normalize(instance,[0,1]);
//  cc = libsvm_svmtrain(label,scaled_instance);
//  [predicted_label,accuracy]=libsvm_svmpredict(label,libsvm_normalize(instance,scaled_parameters),cc);
// disp("accuracy: "+string(accuracy(1))+" %");
// See also
//   libsvm_scale
// Authors
// Holger Nahrstaedt


        [nargout,nargin]=argn(0);
	//rand('state',0); // reset random seed

	if nargin < 1
		error("[scaled_instance,scaling_param] = svmnormalize(instance,[meanV,stdV])");
        elseif nargin < 2
                meanV = 0;
                stdV = 1;
                y_scaling=%f;
                rescaling=%f;
        elseif nargin < 3 
                if length(x) == 2 then
                   meanV=x(1);
                   stdV=x(2);
                   rescaling=%f;
                else
                  rescaling=%t;
                end;
                y_scaling=%f;
        else
                y_scaling=%t;
               

	end;

max_index = 0;
num_nonzeros = 0;
new_num_nonzeros = 0;



index=size(instance,2);


       if (rescaling) then
          if ((size(x,2)~=2) | (size(x,1)~=(index+1))) then
            error ("dim of scaled_parameters does not fit with size of instance!");
          end;
          meanV=x(1,1);
          stdV=x(1,2);
          feature_mean=x(2:$,1);
          feature_std=x(2:$,2);


         if (y_scaling) then
            if ((size(y,2)~=2) | (size(y,1)~=2)) then
               error ("dim of scaled_label_parameters does not fit!");
            end;
            y_meanV = y(1,1);
            y_stdV = y(1,2);
            y_mean = y(2,1); 
            y_std = y(2,2);


        end;


     else



	  feature_mean=ones(index,1)*(-%inf);
	  feature_std=ones(index,1)*(%inf);

	  for i=1:index
	    feature_mean(i)=mean(full(instance(:,i)));
	    feature_std(i)=stdev(full(instance(:,i)));

	  end


           if (y_scaling) then
            if (length(y)~=2) then
               error ("dim of scaled_label_parameters does not fit!");
            end;
                y_meanV=y(1);
                y_stdV=y(2);
                y_mean = mean(label);
                y_std = stdev(label);
          end;
    end

   scaled_instance=instance;
    for i=1:index
	  scaled_instance(:,i) = (scaled_instance(:,i)-feature_mean(i))/(feature_std(i)/stdV)+meanV;
     end;


if(y_scaling) then
  scaled_label=label;
  for i=1:length(label)

          scaled_label(i) = (label(i) - y_mean)/(y_std/y_stdV)+meanV;
  end;
end

if nargout >1 then
  scaled_parameters=[meanV,stdV;feature_mean(:),feature_std(:)];
end;

if  nargout >3 then
  scaled_label_parameters=[y_meanV,y_stdV;y_mean,y_std];

 end;
endfunction
