function [HMS, HMSEE] = hilbertVMD(u, inter, prec)
    /*
    This functions calculates the Hilbert Spectrum and
    Hilbert Marginal spectrum of the signal decomposition
    */
    /*
    Inputs and parameters
    u      - VMD decomposition signals
    inter  - Interval from which t will range [0, inter]
    ---------------------------
    HS     - Hilbert Spectrum
    HMS    - Hilbert Marginal Spectrum
    
    */
    
    //defining the hilbert spectrum, instantenous frequency
    
    
    
    
    
    [K , time] = size(u); //unpacking number of mode functions and length of the signal
    
    //HS = zeros(u); //Hilbert spectrum H(omega, t)
    
    omeg_k = zeros(u); // instantenous angle frequency
    
    teta_k = zeros(u); //angle of the analytic signal
    
    step = inter/time; //step of the grid
    
    interval = linspace(0, inter, time); 
    
    AS = zeros(u); //analytic signal

    


    
    for k = 1:K
        
        AS(k, :) = hilbert(u(k, :)); //calculating the analytical signal of every mode
       
        teta_k(k, :) = atan(imag(AS(k,:))./real(AS(k, :))); //instantaneous phase
        
        omeg_k(k,1:$-1) = diff(teta_k(k,:))/step; //instantaneous frequency
        
        omeg_k(k, $) = omeg_k(k, $-1); // checked!
        
        A_k(k, :) = sqrt(imag(AS(k, :)).^2 + real(AS(k, :)).^2); //instantaneous amplitude
        
    end
    
    //teta_k = exp(%i*teta_k);
    //disp(norm(imag(AS./teta_k))); //to check whether teta_k is well defined
    // disp(norm(reHS-u)); to check whether the analytical signal is ok
    
    
    
    
    //inter2 = min(omeg_k):(step*(max(omeg_k)-min(omeg_k))/inter):max(omeg_k);
    
    minn = min(omeg_k); //minimum in omega
    
    inter2 = minn:prec:max(omeg_k); //check if 2000 is enough
    
    aux = length(inter2);
    
    HMS = zeros(aux,K);
    
    
    /* to check if everything is ok.
    //some control variables
    disp("min(inter2)")
    disp(inter2(1))
    disp("-----------")
    disp("max(inter2)")
    disp(inter2($))
    disp("-----------")
    disp("aux")
    disp(aux)
    disp("-----------")
    disp("HMS")
    disp(size(HMS))
    disp("-----------")
    disp("A_k")
    disp(size(A_k))
    disp("-----------")
    disp("interval of time")
    disp(size(interval));
    disp("-----------")
    disp("time")
    disp(time)
    */
    
    //Calculating HMS
    
    for k = 1:K
        
        //calculating the integral for all k
        for j = 1:time
            
            //adding the integral
            i = int((omeg_k(k, j) - minn)/prec + 1);
            omega = inter2(i);
            if abs(omega - omeg_k(k, j)) <= prec
                
                HMS(i, k) = HMS(i, k) + A_k(k,j)* prec;
            end //end first if
            
            if i>2
                omega = inter2(i-1);
                if abs(omega - omeg_k(k, j)) <= prec
                    HMS(i-1, k) = HMS(i-1, k) + A_k(k,j)* prec;
                end
            end //end second if
            
            if i<aux
                omega = inter2(i+1);
                if abs(omega - omeg_k(k, j)) <= prec
                    HMS(i+1, k) = HMS(i+1, k) + A_k(k,j)* prec;
                end
                
            end //end third if
        end
    end
 
    
    Tot_energy = 0
    
    E_k = zeros(K, 1)
    //Calculating the energy
    
    for  k = 1:K
        
        E_k(k) = norm(HMS(:,k)) * prec;
        
        
        Tot_energy = Tot_energy + E_k(k)
    end
  
    for k = 1:K
        pk = E_k(k)/Tot_energy;
        HMSEE(k) = - pk * log(pk);
    end
    
    
    
    
    
    
    

endfunction
   
