function TF = SEntropy(ST)
    %This function will return the feature vector for the 
    %S-transform methods
    
    %inputs
    % ST - The s transform of the signal, it's a matrix of complex values
    
    %outputs
    % TF - Is a vector composed of two parts, the frequency like entropy
    %      and the time like entropy
    
    ST = abs(ST);
    %constants of divisions of the matrix
    [r, c] = size(ST);
    I = (r-mod(r, 10))/10;
    J = (c-mod(c, 30))/30;
    E = sum(ST(:));
    Eij = zeros(10, 30);
    for ii = 0:9
        for jj = 0:29
            begi = ii*I + 1;
            begj = jj*J + 1;
            if ii == 9
               fini = r;
            else
                fini = (ii+1) * I;
            end
            if jj == 29
                finj = c;
            else
                finj = (jj+1) * J;
            end
            aux = ST(begi:fini, begj:finj);
            Eij(ii+1, jj+1) = sum(aux(:))/E;
        end
    end
    
    %now lets calculate the vectors T and F, for time and frequency
    %respectively
    
    T = sum(Eij, 1);
    F = sum(Eij, 2).';
    TF = [T, F];
    

end