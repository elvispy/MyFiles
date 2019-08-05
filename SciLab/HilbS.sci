function [HMS, HS] = hilbertVMD(u, inter, prec)
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
        
        omeg_k(k, $) = omeg_k(k, $-1); // checked!
        
        A_k(k, :) = sqrt(imag(AS(k, :)).^2 + real(AS(k, :)).^2);
        
    end
    
    //teta_k = exp(%i*teta_k);
    //disp(norm(imag(AS./teta_k))); //to check whether teta_k is well defined
    // disp(norm(reHS-u)); to check whether the analytical signal is ok
    
    
    
    
    //inter2 = min(omeg_k):(step*(max(omeg_k)-min(omeg_k))/inter):max(omeg_k);
    
    inter2 = linspace(min(omeg_k), max(omeg_k), time); //check if 2000 is enough
    aux = length(inter2);
    
    HMS = zeros(aux,1);
    
    
    /*
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
    
    
    for i = 1:aux
        //calculating h(omega) for all omega
        omega = inter2(i);
        disp(i)
        for k = 1:K
            //calculating the integral for all k
            for j = 1:time
                //adding the integral
                if abs(omega - omeg_k(k, j)) < prec
                    HMS(i) = HMS(i) + A_k(k,j)* interval(j);
                end
            end
        end
        clc;
    end
    
    
    
    
    
    
    
    
 
endfunction
