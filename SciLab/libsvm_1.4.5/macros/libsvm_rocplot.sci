function auc = libsvm_rocplot(y,x,params,uselinear)
//plotroc draws the recevier operating characteristic(ROC) curve for an svm-model
// Calling Sequence
//auc = libsvm_rocplot(training_label, training_instance) 
//auc = libsvm_rocplot(training_label, training_instance , model) 
//auc = libsvm_rocplot(training_label, training_instance , libsvm_options) 
//auc = libsvm_rocplot(training_label, training_instance , libsvm_options, uselinear) 
// Description
//  Use cross-validation on training data to get decision values and plot ROC curve.
//
//  Use the given model to predict testing data and obtain decision values  for ROC
// Examples
//   
//      [label,instance]=libsvmread(fullfile(libsvm_getpath(),"demos","heart_scale"));
//      // 5-fold cross-classiﬁcation, training of svm is done inside of libsvm_rocplot
// 	libsvm_rocplot(label, instance,'-v 5');
//
//      // training using libsvm_svmtrain
//   	model = libsvm_svmtrain(label,instance);
// 	libsvm_rocplot(label,instance,model);
//      
//      //--------------------------
//      //libsvm_rocplot for linear models
//      [label,instance]=libsvmread(fullfile(libsvm_getpath(),"demos","heart_scale"));
//      // 5-fold cross-classiﬁcation, training of svm is done inside of libsvm_rocplot
// 	libsvm_rocplot(label, instance,'-v 5',%t); 
// 	
// 	// training using train
//   	model = libsvm_lintrain(label,instance);
// 	libsvm_rocplot(label,instance,model);
// See also
//   libsvm_confmat
//   libsvm_partest
// Authors
//  Holger Nahrstaedt

        [nargout,nargin]=argn(0);
	//rand('state',0); // reset random seed
        y=cl101(y);
       
        if nargin < 4 then
           uselinear =%f;
        end;
              
     
	if nargin < 2
		error("auc = libsvm_rocplot(testing_label, testing_instance, model,uselinear)");
	elseif isempty(y) | isempty(x)
		error('Input data is empty');
	elseif sum(y == 1) + sum(y == -1) ~= length(y)
		error('ROC is only applicable to binary classes with labels 1, -1'); // check the trainig_file is binary
	elseif exists('params') & type(params)~=10
		model = params;
                try
		  [predict_label,mse,deci] = libsvm_svmpredict(y,x,model); // the procedure for predicting
		  if isempty(predict_label) then
		  [predict_label,mse,deci] = libsvm_linpredict(y,x,model); 
		  end;
                catch
                  [predict_label,mse,deci] = libsvm_linpredict(y,x,model); 
                end
		auc = roc_curve(deci*y(1),y);
	else
		if ~exists('params')
			params = "-v 5";
		end
		[params,fold] = proc_argv(params); // specify each parameter
		if fold <= 1
			error('The number of folds must be greater than 1');
		else	 // get the value of decision and label after cross-calidation
			
		    prob_y=y;
		    prob_x=x;
		    nr_fold=fold;

		    l=length(prob_y);
			    deci = ones(l,1);
			    label_y = ones(l,1);	 
			    
			    [junk,rand_ind] = mtlb_sort (rand (1, l));
			    for i=1:nr_fold // Cross training : folding
				    test_ind=rand_ind([floor((i-1)*l/nr_fold)+1:floor(i*l/nr_fold)]');
				    train_ind = [1:l]';
				    train_ind(test_ind) = [];
				    if (isempty(params) | type(params)~=10) then
					  params="";
				    end;
				    //     model = svmtrain(prob_y(train_ind),prob_x(train_ind,:));
				    //else
                                   // disp(size(prob_y(train_ind)));
                                   // disp(size(prob_x(train_ind,:)));
                                   // disp(size(params)); disp(type(params));
                                   if (uselinear)
                                       CC = libsvm_lintrain(prob_y(train_ind),prob_x(train_ind,:),params);
                                   else
				      CC = libsvm_svmtrain(prob_y(train_ind),prob_x(train_ind,:),params);
                                   end;
				    //end;
				    //disp(size(CC));
				   // disp(type(CC));
                                     if (uselinear)
                                          [predict_label,mse,subdeci] = libsvm_linpredict(prob_y(test_ind),prob_x(test_ind,:),CC);
                                    else
                         		   [predict_label,mse,subdeci] = libsvm_svmpredict(prob_y(test_ind),prob_x(test_ind,:),CC);
 				    end;
                                    deci(test_ind) = subdeci.*CC.Label(1);
				    label_y(test_ind) = prob_y(test_ind);
			    end


			auc = roc_curve(deci,label_y); // plot ROC curve
		end
	end
endfunction



function [resu,fold] = proc_argv(params)
	resu=params;
	fold=5;
	if ~isempty(params) & ~isempty(regexp(params,'/-v/'))
        [fold_start,fold_end,fold_val] = regexp(params,'/(?<=[-v]\s)[0-9]+/');
        if ~isempty(fold_val)
            fold=eval(fold_val);
            resu=part(params,1:regexp(params,'/-v/')-1);
            if isempty(resu) then
                 resu="";
            end;
        else
            error('Number of CV folds must be specified by ""-v cv_fold""');
        end
    end
endfunction



function auc = roc_curve(deci,label_y)
	//[val,ind] = mtlb_sort(deci,'descend');

        [val,ind] = gsort(deci);
	roc_y = label_y(ind);
	stack_x = cumsum(roc_y == -1)/sum(roc_y == -1);
	stack_y = cumsum(roc_y == 1)/sum(roc_y == 1);
	auc = sum((stack_x(2:length(roc_y),1)-stack_x(1:length(roc_y)-1,1)).*stack_y(2:length(roc_y),1))

        //Comment the above lines if using perfcurve of statistics toolbox
        //[stack_x,stack_y,thre,auc]=perfcurve(label_y,deci,1);
	plot(stack_x,stack_y);
	xlabel('False Positive Rate');
	ylabel('True Positive Rate');
	title(['ROC curve of (AUC = ' string(auc) ' )']);
endfunction

function [CL101,Labels] = cl101(classlabel)
	//// convert classlabels to {-1,1} encoding 


	if (and(classlabel>=0) & and(classlabel==fix(classlabel)) & (size(classlabel,2)==1))
		M = max(classlabel);
		if M==2, 
			CL101 = (classlabel==2)-(classlabel==1); 
		else	
			CL101 = zeros(size(classlabel,1),M);
			for k=1:M, 
				//// One-versus-Rest scheme 
				CL101(:,k) = 2*bool2s(classlabel==k) - 1; 
			end; 
		end; 	
		CL101(isnan(classlabel),:) = %nan; //// or zero ??? 
	        Labels = min(classlabel):M;
	elseif and((classlabel==1) | (classlabel==-1)  | (classlabel==0) )
		CL101 = classlabel; 
		M = size(CL101,2); 
                Labels = 1:M;
	else 
		classlabel,
		error('format of classlabel unsupported');
	end; 
	

endfunction

