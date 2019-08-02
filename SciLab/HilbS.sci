function [HS, HMS] = hilbertVMD(u, inter)
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
    time = size(u)(2);
    
    HS = zeros(u); //Hilbert spectrum H(omega, t)
    
    omeg_k = HS; // instantenous angle frequency
    
    teta_k = omeg_k; //angle of the analytic signal
    
    step = inter/time; //step of the grid
    
    interval = linspace(0, inter, time); 
    
    AS = HS; //analytic signal

    
    K = size(u)(1); //number of mode functions

    
    for k = 1:K
        
        AS(k, :) = hilbert(u(k, :)); //calculating the analytical signal of every mode
        
        teta_k(k, :) = atan(imag(AS(k,:))./real(AS(k, :)));
        
        omeg_k(k,1:$-1) = diff(teta_k(k,:))/step;
        
        omeg_k(k, $) = omeg_k(k, $-1); // i need to check this
        
        A_k(k, :) = sqrt(imag(AS(k, :)).^2 + real(AS(k, :)).^2);
        
    end
    disp(max(omeg_k));
    disp(min(omeg_k));
    //teta_k = exp(%i*teta_k);
    //disp(norm(imag(HS./teta_k))); //to check whether teta_k is well defined
    // disp(norm(reHS-u)); to check whether the analytical signal is ok
    
    
    
    HMS = 0;
endfunction
