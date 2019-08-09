function [best_rate,best_c,best_g,rate_matrix] = libsvm_grid(label,instance,log2c,log2g,fold,option_string)
// parameter selection tool for C-SVM classification using the RBF (radial basis function) kernel
// Calling Sequence
//   [best_rate,best_c,best_g] = libsvm_grid(label,instance)
//   [best_rate,best_c,best_g] = libsvm_grid(label,instance,log2c,log2g)
//   [best_rate,best_c,best_g] = libsvm_grid(label,instance,log2c,log2g,v)
//   [best_rate,best_c,best_g] = libsvm_grid(label,instance,log2c,log2g,v,option_string)
//  Parameters
//  log2c : [begin,end,step]
//  log2g : [begin,end,step]
//  v : fold
//  option_string: additional parameters for svmtrain
//  best_rate : cross validation accuracy for the best parameter combination
//  best_c : best parameter c 
//  best_g : best parameter gamma
//  Description
//  libsvm_grid is a parameter selection tool for C-SVM classification using
//the RBF (radial basis function) kernel. It uses cross validation (CV)
//technique to estimate the accuracy of each parameter combination in
//the specified range and helps you to decide the best parameters for
//your problem.
// Examples
//    [label,instance]=libsvmread(fullfile(libsvm_getpath(),"demos","heart_scale"));
//    [best_rate,best_c,best_g] = libsvm_grid(label,instance)
//
//See also
//libsvm_gridlinear
// Authors
// Holger Nahrstaedt
// 


        [nargout,nargin]=argn(0);
	//rand('state',0); // reset random seed

        
         if nargin<3 then
              log2c=[ -5, 15, 2];
              log2g=[ 3, -15, -2]; 
               fold = 5;
         elseif isempty(log2c) then
             log2c=[ -5, 15, 2];
         end;

         if nargin<4 then
               log2g=[ 3, -15, -2]; 
               fold = 5;
        elseif isempty(log2g) then
              log2g=[ 3, -15, -2]; 
         end;

         if nargin<5 then
               fold = 5;
         elseif isempty(fold) then
               fold = 5;
         end;

         if nargin<6 then
               option_string = "";
         end;

       
         c_seq=log2c(1):log2c(3):log2c(2);
         g_seq=log2g(1):log2g(3):log2g(2);

         best_rate = -1;
         best_c1=0;
         best_g1=0;
         best_c=0;
         best_g=0;

         rate_matrix=zeros(length(c_seq),length(g_seq));


         [junk, c_seqind] = mtlb_sort (rand (1, length(c_seq)));
         [junk, g_seqind] = mtlb_sort (rand (1, length(g_seq)));

         //scf(1);clf(1);

         for c=c_seq(c_seqind)
           for g=g_seq(g_seqind)
            
               rate = libsvm_svmtrain(label,instance,"-c "+string(2^c)+" -g "+string(2^g)+" -v "+string(fold)+" -q "+option_string);

              if sum(rate_matrix)==0 then
                  rate_matrix=ones(length(c_seq),length(g_seq))*rate;
              end;
              if (rate>best_rate | (rate==best_rate & g==best_g1 & c<best_c1)) then
                    best_rate = rate;
                    best_c1=c;
                    best_g1=g;
                    best_c = 2^c;
                    best_g = 2^g;
                    disp("best c "+string(best_c)+" best g "+string(best_g)+" best rate "+string(best_rate));
              end;
                   rate_matrix(find(c==c_seq),find(g==g_seq))=rate;
           end;
        end;

     scf(1);clf(1);
     contour2d(c_seq, g_seq,rate_matrix,6);
     xlabel("log(c)");
     ylabel("log(g)");



endfunction