function [HMS, rango, HMSEE] = HilbS(u, inter, prec)
    
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
    
    teta_k = zeros(aux); %angle of the analytic signal
    
    step = inter/time; %step of the grid
    
    %interval = linspace(0, inter, time); 
    
    AS = zeros(aux); %analytic signal
    
    A_k = zeros(aux);

    


    
    for k = 1:K
        
        AS(k, :) = hilbert(u(k, :)); %calculating the analytical signal of every mode
       
        teta_k(k, :) = atan(imag(AS(k,:))./real(AS(k, :))); %instantaneous phase
        
        omeg_k(k,1:end-1) = diff(teta_k(k,:))/step; %instantaneous frequency
        
        omeg_k(k, end) = omeg_k(k, end-1); % checked!
        
        A_k(k, :) = sqrt(imag(AS(k, :)).^2 + real(AS(k, :)).^2); %instantaneous amplitude
        
    end
    
    %teta_k = exp(%i*teta_k);
    %disp(norm(imag(AS./teta_k))); //to check whether teta_k is well defined
    % disp(norm(reHS-u)); to check whether the analytical signal is ok
    
    
    
    minn = min(omeg_k(:)); %minimum in omega

    rank = max(omeg_k(:))-minn;

    rank = floor(rank/prec)+1;

    
    rango = [minn, max(omeg_k(:))];
    
    HMS = zeros(rank,K);
    
    %Calculating HMS
    
    for k = 1:K
        
        %calculating the integral for all k
        for j = 1:time
            
            %adding the integral
            i = floor((omeg_k(k, j) - minn)/prec + 1);
            omega = minn + (i-1)*prec;
            
            if abs(omega - omeg_k(k, j)) < prec
                HMS(i, k) = HMS(i, k) + A_k(k,j)* prec;
            end %end first if
            
            if i>2
                omega = minn + (i-2) * prec;
                if abs(omega - omeg_k(k, j)) < prec
                    HMS(i-1, k) = HMS(i-1, k) + A_k(k,j)* prec;
                end
            end %end second if
            
            if i<rank
                omega = minn + i * prec;
                if abs(omega - omeg_k(k, j)) < prec
                    HMS(i+1, k) = HMS(i+1, k) + A_k(k,j)* prec;
                end
                
            end %end third if
        end %end inner for
    end %end outer for

    
    
    Tot_energy = zeros(K, 1);
    
    E_k = zeros(floor((rank-1)/100)+1, K);
    %Calculating the energy
    
    
    for  k = 1:K
        for i = 0:floor((rank-1)/100)
            try
                
                E_k(i+1, k) = norm(HMS((i*100+1):((i+1)*100),k), 2)^2 * prec;
                
            catch
                E_k(i+1, k) = norm(HMS((i*100+1):end, 2))^2 * prec;
            end
            
            Tot_energy(k) = Tot_energy(k) + E_k(i+1, k);
            
        end
        
    end
    HMSEE = zeros(K, 1);
    for k = 1:K
        for i = 1:size(E_k, 1)
            pk = E_k(i, k)/Tot_energy(k);
            if ~(pk == 0)
                HMSEE(k) = HMSEE(k) - pk * log(pk);
            end
        end
    end

