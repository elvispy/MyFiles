function  libsvm_savemodel(model_file_name,CC)
// saves a model into a text file
// Calling Sequence
//  libsvm_savemodel(filename,model)
//  Parameters
//  filename : string
//  model : model from libsvm_train
//  Description
// Saves a model into a text file. The textfile can be loaded by the c++ function svm_load_model from the libsvm toolbox.
// Examples
// label_vector=[zeros(20,1);ones(20,1)];
// instance_matrix = [rand(20,2); -1*rand(20,2)];
// model=libsvm_svmtrain(label_vector,instance_matrix);
// libsvm_savemodel("testmodel.txt",model)
//
//See also
//libsvm_loadmodel
// Authors
// Holger Nahrstaedt

fp = mopen(model_file_name,'w');

// 	FILE *fp = fopen(model_file_name,"w");
// 	if(fp==NULL) return -1;
//
// 	char *old_locale = strdup(setlocale(LC_ALL, NULL));
// 	setlocale(LC_ALL, "C");
//
// 	const svm_parameter& param = model->param;

	svm_type_table =["c_svc","nu_svc","one_class","epsilon_svr","nu_svr",""];


        kernel_type_table = ["linear","polynomial","rbf","sigmoid","precomputed",""];

	mfprintf(fp,"svm_type %s\n", svm_type_table(CC.Parameters(1)+1));

	mfprintf(fp,"kernel_type %s\n", kernel_type_table(CC.Parameters(2)+1));

	if(CC.Parameters(2) == 1)
		mfprintf(fp,"degree %d\n", CC.Parameters(3));
	end;

	if(CC.Parameters(2) == 1 | CC.Parameters(2) == 2 | CC.Parameters(2) == 3)
		mfprintf(fp,"gamma %g\n", CC.Parameters(4));
	end;

	if(CC.Parameters(2) == 1 | CC.Parameters(2) == 3)
		mfprintf(fp,"coef0 %g\n", CC.Parameters(5));
	end;

	 nr_class = CC.nr_class;
	l = CC.totalSV;
	mfprintf(fp, "nr_class %d\n", CC.nr_class);
	mfprintf(fp, "total_sv %d\n",CC.totalSV);


		mfprintf(fp, "rho");
		for i=1:(nr_class*(nr_class-1)/2)
			mfprintf(fp," %g",CC.rho(i));
		end;
		mfprintf(fp, "\n");


	if(~isempty(CC.Label))

		mfprintf(fp, "label");
		for i=1:nr_class
			mfprintf(fp," %d",CC.Label(i));
		end;
		mfprintf(fp, "\n");
	end;
  // if(~isempty(CC.sv_indices))
	//
  //     mfprintf(fp, "sv_indices");
  //     for i=1:length(CC.sv_indices)
  //       mfprintf(fp," %d",CC.sv_indices(i));
  //     end;
  //     mfprintf(fp, "\n");
	//
  // end;
	if(~isempty(CC.ProbA)) // regression has probA only

		mfprintf(fp, "probA");
		for i=1:(nr_class*(nr_class-1)/2)
			mfprintf(fp," %g",CC.ProbA(i));
		end;
		mfprintf(fp, "\n");
	end;
	if(~isempty(CC.ProbB))

		mfprintf(fp, "probB");
		for i=1:(nr_class*(nr_class-1)/2)
			mfprintf(fp," %g",CC.ProbB(i));
		end;
		mfprintf(fp, "\n");
	end;

	if(~isempty(CC.nSV))

		mfprintf(fp, "nr_sv");
		for i=1:nr_class
			mfprintf(fp," %d",CC.nSV(i));
		end;
		mfprintf(fp, "\n");
	end;

	mfprintf(fp, "SV\n");
	//const double * const *sv_coef = model->sv_coef;
	//const svm_node * const *SV = model->SV;

	for i=1:l

		for j=1:nr_class-1
			mfprintf(fp, "%.16g ",CC.sv_coef(i,j));
		end;

		//const svm_node *p = SV[i];
		p=0;
		if(CC.Parameters(2) == 4)
			mfprintf(fp,"0:%d ",CC.SVs(i,p));
		else
			while(p<size(CC.SVs,2))

				mfprintf(fp,"%d:%.8g ",p,CC.SVs(i,p+1));
				p=p+1;
			end;
		end;
		mfprintf(fp, "\n");
	end;
	mclose(fp);
	//setlocale(LC_ALL, old_locale);
	//free(old_locale);

	//if (ferror(fp) != 0 || fclose(fp) != 0) return -1;
	//else return 0;
endfunction
