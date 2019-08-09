function [best_rate,best_c,best_s] = libsvm_gridlinear(label,instance,log2c,s_seq,fold,option_string)
// parameter selection tool for linear classification
// Calling Sequence
//   [best_rate,best_c,best_s] = libsvm_gridlinear(label,instance)
//   [best_rate,best_c,best_s] = libsvm_gridlinear(label,instance,log2c)
//   [best_rate,best_c,best_s] = libsvm_gridlinear(label,instance,log2c,s_seq)
//   [best_rate,best_c,best_s] = libsvm_gridlinear(label,instance,log2c,s_seq,v)
//   [best_rate,best_c,best_s] = libsvm_gridlinear(label,instance,log2c,s_seq,v,option_string)
//  Parameters
//  log2c : [begin,end,step]
//  s_seq : linear kernels (0 - 7, 11 - 13), e.g. [0 1 4]
//  v : fold
//  option_string: additional parameters for svmtrain
//  best_rate : cross validation accuracy for the best parameter combination
//  best_c : best parameter c 
//  best_s : best linear kernel
//  Description
//  libsvm_gridlinear is a parameter selection tool for linear classification. It uses cross validation (CV)
//technique to estimate the accuracy of each parameter combination in
//the specified range and helps you to decide the best parameters for
//your problem.
// Examples
//    [label,instance]=libsvmread(fullfile(libsvm_getpath(),"demos","heart_scale"));
//    [best_rate,best_c,best_s] = libsvm_gridlinear(label,instance)
//  See also
//    libsvm_grid
// Authors
// Holger Nahrstaedt
// 

        [nargout,nargin]=argn(0);
	//rand('state',0); // reset random seed


         if nargin<3 then
              log2c=[ -5, 15, 2];
               s_seq=[0, 1, 2, 3, 5, 6, 7];
               fold = 5;
         end;

         if nargin<4 then
               s_seq=[0, 1, 2, 3, 5, 6, 7];
               fold = 5;
         end;

         if nargin<5 then
               fold = 5;
         end;

         if nargin<6 then
               option_string = "";
         end;


         c_seq=log2c(1):log2c(3):log2c(2);

         best_rate = -1;
         best_c1=0;
         best_c=0;
         best_s=0;

         rate_matrix=zeros(length(c_seq),length(s_seq));


         [junk, c_seqind] = mtlb_sort (rand (1, length(c_seq)));
         [junk, s_seqind] = mtlb_sort (rand (1, length(s_seq)));

         //scf(1);clf(1);

         for c=c_seq(c_seqind)
           for s=s_seq(s_seqind)
            
              rate = libsvm_lintrain(label,instance,"-s "+string(s)+" -c "+string(2^c)+" -v "+string(fold)+" -q "+option_string);
            
              if sum(rate_matrix)==0 then
                  rate_matrix=ones(length(c_seq),length(s_seq))*rate;
              end;
              if (rate>best_rate | (rate==best_rate & s==best_s & c<best_c1)) then
                    best_rate = rate;
                    best_c1=c;
                    best_s=s;
                    best_c = 2^c;
       
                    disp("best s "+string(best_s)+" best c "+string(best_c)+" best rate "+string(best_rate));
              end;
                   rate_matrix(find(c==c_seq),find(s==s_seq))=rate;
           end;
        end;

     scf(1);clf(1);
     contour2d(c_seq, s_seq,rate_matrix,6);
     xlabel("log(c)");
     ylabel("s");
     xgrid();


endfunction
