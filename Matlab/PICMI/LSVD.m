function [lsvd] = LSVD(imfs, N)
    %This function tries to exploit feature extraction on HVCB via LSVD
    
    %Parameters:
    % imfs --- Is the matrix of IMF's that make the original signal
    % N    --- THe number of elements in the local singular value
    % decomposition
    %One signal per row is expected
    
    % LSVD --- A vector of local singular Value decomposition values
    
    
    [~, T] = size(imfs);
    
    lsvd = zeros(N, 1);
    
    T_ = (T-mod(T, N))/N; %residual
    
    for ii = 1:N
        if ii == N 
            lsvd(ii) = max(svd(imfs(:, (T_ * (ii-1) +1):end)));
        else
            lsvd(ii) = max(svd(imfs(:, (T_ * (ii -1) +1):T_ * ii)));
        end
    end
end