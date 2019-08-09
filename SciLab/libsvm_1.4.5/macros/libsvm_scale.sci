function [scaled_instance,scaled_parameters,scaled_label,scaled_label_parameters] = libsvm_scale(instance,x,label,y)
//scale the input data for correct learning
// Calling Sequence
//   [scaled_instance,scaled_parameters] = libsvm_scale(instance);
//   [scaled_instance,scaled_parameters] = libsvm_scale(instance,[lower,upper]);
//
//   [scaled_instance] = libsvm_scale(instance,scaled_parameters);
//   
//  [scaled_instance,scaled_parameters,scaled_label,scaled_label_parameters] = libsvm_scale(instance,[lower,upper],label,[label_lower, label_upper]);
//  Description
//  
//  Scaling before applying SVM is very important in order to avoid several  numerical problems! Normally good ranges are [0,1] or [-1,+1]. 
//  Each feature row in the instance matrix has be scaled indepented from the other features.
//  
//  It is important to scale the testing data with the same scale as the training data!
//  Examples
//  [label,instance]=libsvmread(fullfile(libsvm_getpath(),"demos","heart_scale"));
//  [scaled_instance,scaled_parameters] = libsvm_scale(instance,[-1,1]);
//  cc = libsvm_svmtrain(label,scaled_instance);
//  [predicted_label,accuracy]=libsvm_svmpredict(label,svmnormalize(instance,scaled_parameters),cc);
// disp("accuracy: "+string(accuracy(1))+" %");
// See also
//   libsvm_normalize
// Authors
//  Holger Nahrstaedt


        [nargout,nargin]=argn(0);
	//rand('state',0); // reset random seed

	if nargin < 1
		error("[scaled_instance,scaling_param] = libsvm_scale(instance,[lower,upper])");
        elseif nargin < 2
                lower = -1;
                upper = 1;
                y_scaling=%f;
                rescaling=%f;
        elseif nargin < 3 
                if length(x) == 2 then
                   lower=x(1);
                   upper=x(2);
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
          lower=x(1,1);
          upper=x(1,2);
          feature_min=x(2:$,1);
          feature_max=x(2:$,2);


         if (y_scaling) then
            if ((size(y,2)~=2) | (size(y,1)~=2)) then
               error ("dim of scaled_label_parameters does not fit!");
            end;
            y_lower = y(1,1);
            y_upper = y(1,2);
            y_min = y(2,1); 
            y_max = y(2,2);


        end;


     else



	  feature_max=ones(index,1)*(-%inf);
	  feature_min=ones(index,1)*(%inf);

	  for i=1:index
	    feature_max(i)=max(instance(:,i));
	    feature_min(i)=min(instance(:,i));

	  end

	  for i=1:index
	    feature_max(i)=max(feature_max(i),0);
	    feature_min(i)=min(feature_min(i),0);

	  end
           if (y_scaling) then
            if (length(y)~=2) then
               error ("dim of scaled_label_parameters does not fit!");
            end;
                y_lower=y(1);
                y_upper=y(2);
                y_max = max(label);
                y_min = min(label);
          end;
    end

   scaled_instance=instance;
    for i=1:index
	  scaled_instance(:,i) = lower + (upper-lower) * (scaled_instance(:,i)-feature_min(i))/(feature_max(i)-feature_min(i));
     end;


if(y_scaling) then
  scaled_label=label;
  for i=1:length(label)
                if (label(i) == y_min) then
			scaled_label(i) = y_lower;
		elseif(label(i) == y_max) then
			scaled_label(i) = y_upper;
		else 
                       scaled_label(i) = y_lower + (y_upper-y_lower) *    (label(i) - y_min)/(y_max-y_min);
                end;
  end;
end

if nargout >1 then
  scaled_parameters=[lower,upper;feature_min(:),feature_max(:)];
end;

if  nargout >3 then
  scaled_label_parameters=[y_lower,y_upper;y_min,y_max];

 end;
endfunction
