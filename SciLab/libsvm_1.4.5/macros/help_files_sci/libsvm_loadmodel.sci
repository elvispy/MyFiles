function  CC = libsvm_loadmodel(model_file_name)
// loads a model from a text file
// Calling Sequence
//  model = libsvm_loadmodel(model_file_name)
//  Parameters
//  filename : string
//  model : model from libsvm_train
//  Description
// Loads a model from a text file. The format is compatible  to svm_save_model and svm_load_model from the c++ function of the libsvm toolbox.
// Examples
// label_vector=[zeros(20,1);ones(20,1)];
// instance_matrix = [rand(20,2); -1*rand(20,2)];
// model=libsvm_svmtrain(label_vector,instance_matrix);
// libsvm_savemodel("testmodel.txt",model)
// clear model;
// model = libsvm_loadmodel("testmodel.txt")
//
//
//See also
//libsvm_savemodel
// Authors
// Holger Nahrstaedt
	svm_type_table =["c_svc","nu_svc","one_class","epsilon_svr","nu_svr",""];


        kernel_type_table = ["linear","polynomial","rbf","sigmoid","precomputed",""];

fp = mopen(model_file_name,'rb');
CC = struct("Parameters",[],"nr_class",[],"totalSV",[],"rho",[],"Label",[],"sv_indices",[],"ProbA",[],"ProbB",[],"nSV",[],"sv_coef",[],"SVs",[]);
CC.Parameters = zeros(5,1);
while (%t)
cmd = mfscanf(fp,"%s80");

if(~isempty(strstr(cmd,"svm_type"))) then

  cmd = mfscanf(fp,"%s80");
    for i=1:6

      if(~isempty(strstr(cmd,svm_type_table(i)))) then

      	CC.Parameters(1)=i-1;
      	break;
      end;
      if (i==6) then
	       error("unknown svm type.");
      end;
    end;

elseif(~isempty(strstr(cmd,"kernel_type"))) then
    cmd = mfscanf(fp,"%s80");
    for i=1:6

      if(~isempty(strstr(cmd,kernel_type_table(i)))) then
				CC.Parameters(2)=i-1;
				break;
      end;
      if (i==6) then
				error("unknown kernel function.");
      end;
    end;
elseif(~isempty(strstr(cmd,"degree"))) then
	CC.Parameters(3)=mfscanf(fp,"%d");
elseif(~isempty(strstr(cmd,"gamma"))) then

CC.Parameters(4)=mfscanf(fp,"%f");
elseif(~isempty(strstr(cmd,"coef0"))) then


CC.Parameters(5) = mfscanf(fp,"%lf");
elseif(~isempty(strstr(cmd,"nr_class"))) then

CC.nr_class = mfscanf(fp,"%d");
elseif(~isempty(strstr(cmd,"total_sv"))) then

CC.totalSV=mfscanf(fp,"%d");
elseif(~isempty(strstr(cmd,"rho"))) then

  for i=1:(CC.nr_class * (CC.nr_class-1)/2)
    CC.rho(i) = mfscanf(fp,"%lf");
  end;
elseif(~isempty(strstr(cmd,"label"))) then
	for  i=1:CC.nr_class
	CC.Label(i) = mfscanf(fp,"%d");
	end;
// elseif(~isempty(strstr(cmd,"sv_indices"))) then
// 		for i=1:(CC.nr_class * (CC.nr_class-1)/2)
// 				CC.sv_indices(i) = mfscanf(fp,"%d");
// 		end;
elseif(~isempty(strstr(cmd,"probA"))) then

  for i = 1:(CC.nr_class * (CC.nr_class-1)/2)
    CC.ProbA(i) = mfscanf(fp,"%lf");
  end;
elseif(~isempty(strstr(cmd,"probB"))) then
  for i = 1:(CC.nr_class * (CC.nr_class-1)/2)
    CC.ProbB(i) = mfscanf(fp,"%lf");
  end;


elseif(~isempty(strstr(cmd,"nr_sv"))) then
 for i = 1:CC.nr_class
    CC.nSV(i) = mfscanf(fp,"%d");
 end;


elseif(~isempty(strstr(cmd,"SV"))) then
  c=0;
  while(~(c==4 | c==10))
    c = mget(1,"c",fp);
  end;
  break;
end;
end;

l = CC.totalSV;
nr_class=CC.nr_class;
CC.sv_coef = zeros(l,nr_class-1);
for i=1:l
  line=mgetl(fp,1);
  v = strsplit(line," ");
  v_ind=1;
  for j=1:nr_class-1
    CC.sv_coef(i,j) = msscanf(v(v_ind),"%lf");
    v_ind=v_ind+1;
  end;

  if(CC.Parameters(2) == 4)
    CC.SVs(i,1) = msscanf(v(v_ind),"0:%lf");
  else
    for p=0:(size(v,'*')-v_ind-1)
      CC.SVs(i,p+1) = msscanf(v(v_ind),string(p)+":%lf");
      v_ind=v_ind+1;
    end;

  end;
end;


mclose(fp);
	//setlocale(LC_ALL, old_locale);
	//free(old_locale);

	//if (ferror(fp) != 0 || fclose(fp) != 0) return -1;
	//else return 0;
endfunction
