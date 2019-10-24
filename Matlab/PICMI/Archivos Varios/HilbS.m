function [HMS, rango, HMSEE, omeg_k, A_k, teta_k] = HilbS(u, inter, prec)
    
    %This functions calculates the Hilbert Spectrum and
    %Hilbert Marginal spectrum of the signal decomposition
    
    %Inputs and parameters
    %u      - VMD decomposition signals
    %inter  - Interval from which t will range [0, inter]
    %---------------------------
    %HS     - Hilbert Spectrum
    %HMS    - Hilbert Marginal Spectrum
    
   
    
    %defining the hilbert spectrum, instantenous frequency
    
    
    aux = size(u);
    
    K = aux(1);
    time = aux(2);
   
    %HS = zeros(u); //Hilbert spectrum H(omega, t)
    
    omeg_k = zeros(aux); % instantenous angle frequency
    
    step = inter/time; %step of the grid
    
    %interval = linspace(0, inter, time); 

    AS = hilbert(u.').'; %analytic signal
    teta_k = angle(AS); %angle of analytic signal
    A_k = abs(AS); %amplitude of signal
    
    fs = (time-1)/inter;
    for k = 1:K
        omeg_k(k,1:end-1) = fs/(2*pi)*diff(unwrap(teta_k(k,:)));
        
        %omeg_k(k,1:end-1) = diff(teta_k(k,:))/step; %instantaneous frequency
        
        omeg_k(k, end) = omeg_k(k, end-1); % checked!
        
    end
    
    %teta_k = exp(1i*teta_k);
    %disp(norm(imag(AS./teta_k))); //to check whether teta_k is well defined
    %reHS = real(A_k .* teta_k);
    %disp(norm(reHS-u)); %to check whether the analytical signal is ok
    
    minn = min(omeg_k(:)); %minimum in omega
    
    rank = max(omeg_k(:))-minn;

    rank = floor(rank/prec)+1;

    omega_vec = minn:prec:(minn+rank);
    
    rango = [minn, max(omeg_k(:))];
    
    HMS = zeros(size(omega_vec, 2),K);
    
    %Calculating HMS
    
    for k = 1:K
        %calculating the integral for all k
        for j = 1:time
            %adding the integral
            [~, ii] = min(abs(omega_vec - omeg_k(k, j)));
            %ii = floor((omeg_k(k, j) - minn)/prec + 1);
            %omega = minn + (ii-1)*prec;
            HMS(ii, k) = HMS(ii, k) + A_k(k, j) * step;
%             if abs(omega - omeg_k(k, j)) < prec
%                 HMS(ii, k) = HMS(ii, k) + A_k(k,j)* prec;
%             end %end first if
%             
%             if ii>2
%                 omega = minn + (ii-2) * prec;
%                 if abs(omega - omeg_k(k, j)) < prec
%                     HMS(ii-1, k) = HMS(ii-1, k) + A_k(k,j)* prec;
%                 end
%             end %end second if
%             
%             if ii<rank
%                 omega = minn + ii * prec;
%                 if abs(omega - omeg_k(k, j)) < prec
%                     HMS(ii+1, k) = HMS(ii+1, k) + A_k(k,j)* prec;
%                 end    
%            end %end third if
        end %end inner for
    end %end outer for

    
    
    Tot_energy = zeros(K, 1);
    
    E_k = zeros(floor((size(HMS, 1)-1)/100)+1, K);
    %Calculating the energy
    
    
    for  k = 1:K
        for ii = 0:floor((size(HMS, 1)-1)/100)
            try
                E_k(ii+1, k) = norm(HMS((ii*100+1):((ii+1)*100),k), 2)^2 * prec;
            catch
                E_k(ii+1, k) = norm(HMS((ii*100+1):end, k))^2 * prec;
            end
            
            Tot_energy(k) = Tot_energy(k) + E_k(ii+1, k);
            
        end
        
    end
    HMSEE = zeros(K, 1);
    for k = 1:K
        for ii = 1:size(E_k, 1)
            pk = E_k(ii, k)/Tot_energy(k);
            if ~(pk == 0)
                HMSEE(k) = HMSEE(k) - pk * log(pk);
            end
        end
    end

