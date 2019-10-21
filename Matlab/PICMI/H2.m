function [HMS, HMSf, HMSEE, SE] = H2(u, inter)
    %This functions calculates the Hilbert Spectrum and
    %Hilbert Marginal spectrum of the signal decomposition
    
    %Inputs and parameters
    %u      - VMD decomposition signals
    %inter  - Interval from which t will range [0, inter]
    %---------------------------
    %HS     - Hilbert Spectrum
    %HMS    - Hilbert Marginal Spectrum
    %HMSEE  - Hilbert Marginal Spectrum Energy Entropy
    %SE     - Shannon Entropy
prec = 0.01;

aux = size(u);
%number of modes
K = aux(1); 

%number of points in the time grid
time = aux(2); 

%frequency rate (samples per second
fs2 = (time-1)/inter; 
P = hht(u(1, :), fs2, 'FrequencyResolution', prec);
P = size(P);
L = P(1);%omega spectrum
HMS = zeros(L, K);
for ii = 1: K
    [P, f] = hht(u(ii, :), fs2, 'FrequencyResolution', prec);
    HMS(:, ii) = inter * trapz(P, 2) * (time - 1);
end
HMSf = f;

%Total Energy of the Marginal Spectrum, per mode
Tot_energy = zeros(K, 1);

    
E_k = zeros(floor((L-1)/100)+1, K);
%Calculating the energy
HMSEE = zeros(K,1);
step = f(2)-f(1);

 for  k = 1:K
    for ii = 0:floor((L-1)/100)
        try
            E_k(ii+1, k) = step * trapz(HMS((ii*100+1):((ii+1)*100), k).^2);
        catch
            E_k(ii+1, k) = step * trapz(HMS((ii*100+1):end, k).^2);
        end
            
        Tot_energy(k) = Tot_energy(k) + E_k(ii+1, k);
            
    end
        
 end

 for k = 1:K
    for ii = 1:size(E_k, 1)
        pk = E_k(ii, k)/Tot_energy(k);
        if ~(pk == 0)
            HMSEE(k) = HMSEE(k) - pk * log(pk);
        end
    end
 end

 %Shanon Energy
 S_energy = zeros(K, 1);

 E_k = zeros(floor((time-1)/100)+1, K);
 

end



