function [SVD] = localSVD()
//    This function tries to exploit feature extraction on HVCB via LSVD
//    
//    Parameters:
//    
//    u ----- Is the matrix of IMF's that make the original signal
//    
//    Outputs:
//    
//    SVD --- A vector of local Singular Value decomposition


    //stores the current working directory
    curr = pwd();


    //Changing current working directory to the one
    //with the file
    curwd = uigetdir(); 
    chdir(curwd);


    //Selecting and reading the file
    filename = fullfile(curwd, "IMF.csv");

    u = csvRead(filename);

    //obtaining dimensions of the matrix
    [K, N] = size(u);
    
    SVD = zeros(30, 1);
    
    N_ = (N-pmodulo(N, 30))/30;
    
    for i = 1:30
        
        if i == 30  then
            SVD(i) = max(svd(u(:, (N_*(i-1)+1):$)));
        else
            SVD(i) = max(svd(u(:, (N_*(i-1)+1):N_*i)));
        end
    end
    
    chdir(curr);
    
endfunction
