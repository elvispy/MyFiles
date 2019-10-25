function [HMS, HMSf, HMSEE, SE] = H2(u, inter, N)
    %This functions calculates the Hilbert Spectrum and
    %Hilbert Marginal spectrum of the signal decomposition
    
    %Inputs and parameters
    %u      - VMD decomposition signals
    
    %inter  - Interval from which t will range [0, inter]
    %N      - Scalar, representing the number of partitions in the Entropy
    %distribution (equal for both
    %---------------------------
    %HMS    - Hilbert Marginal Spectrum, a matrix in which every column
    % is a diferent mode
    %HMSf   - A vector representing the frequencies of the Hilbert Spectrum
    %HMSEE  - Hilbert Marginal Spectrum Energy a vector of size equal to 
    %the number of modes in the matrix.
    %SE     - Shannon Entropy due to Huang Et al 2011, a vector of size
    %equal to the number of modes in the matrix
    %Link to the paper 
    %https://www.dropbox.com/home/Elvis-CGR/Referencias%20bibliograficas-HVCB?preview=huang2011.pdf
prec = 0.5;

aux = size(u);
%number of modes
K = aux(1); 
%number of points in the time grid
time = aux(2); 

%frequency rate (samples per second)
fs2 = (time-1)/inter; 
P = hht(u(1, :), fs2, 'FrequencyResolution', prec);
P = size(P);
L = P(1);%omega spectrum
HMS = zeros(L, K);

A2_k = zeros(time, K);
for ii = 1: K
    [P, f, ~, ~, imfinse] = hht(u(ii, :), fs2, 'FrequencyResolution', prec);
    HMS(:, ii) = trapz(P, 2)* (inter / (time - 1));
    A2_k(:, ii) = imfinse;
end
HMSf = f;

%Total Energy of the Marginal Spectrum, per mode
Tot_energy = zeros(K, 1);
S_energy = zeros(K, 1);

%Keeping track of both entropies.
E_k = zeros(N, K);
S_k = zeros(N, K);
%Calculating the energy
HMSEE = zeros(K,1);
SE = zeros(K, 1);
step = f(2)-f(1);

 for  k = 1:K
    for ii = 0:(N-1)
        
        %Hilbert Spectrum N
        if ii ~= N-1
            interval = (floor(ii * L / N)+1):floor((ii+1) * L / N);
            E_k(ii+1, k) = step * trapz(HMS(interval, k) .^2);
        else
            E_k(ii+1, k) = step * trapz(HMS((floor(ii * L / N)+1):end, k) .^2);
        end
            
        Tot_energy(k) = Tot_energy(k) + E_k(ii+1, k);
        
        %Shannon N
        
        if ii ~= N-1
            interval = (floor(ii * time / N)+1):floor((ii+1) * time / N);
            S_k(ii+1, k) = step * trapz(A2_k(interval, k));
        else
            S_k(ii+1, k) = step * trapz(A2_k((floor( ii * time / N) + 1):end, k));
        end
        
        S_energy(k) = S_energy(k) + S_k(ii+1, k);
            
            
    end
        
 end

 for k = 1:K
    for ii = 1:N
        %HMS N
        pk = E_k(ii, k)/Tot_energy(k);
        if ~(pk == 0)
            HMSEE(k) = HMSEE(k) - pk * log(pk);
        end
        
        %Shannon N
        
        %shannon kth probability (spk)
        spk = S_k(ii, k)/S_k(k);
        if ~(spk == 0)
            SE(k) = SE(k) - spk * log(spk);
        end
    end
 end

 
 

end



