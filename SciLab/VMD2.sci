function [u, u_hat, omega] = VMD2(signal, alpha, tau, K, DC , init, tol, N, inter)
    /*
    Variational Mode Decomposition
    
    Input and Parameters:
    ---------------------
    signal  - the time domain signal (1D) to be decomposed
    alpha   - th ebalancing parameter of the data-fidelity constraint
    tau     - time-step of the dual ascent (pick 0 for noise-slack)
    K       - The numbers of modes to be recovered
    DC      - true if the first mode is put and kept at DC (0-freq)
    init    - 0 = all omegas start at 0
              1 = all omegas start uniformly distributed (seems good)
              2 = all omegas initialized randomly
    tol     - tolerance of convergence criterion; tipically around 1e-6
    N       - Maximum nmber of iterations allowed.
    
    Outputs:
    --------
    u       - The collection of decomposed modes
    u_hat   - spectra of the modes
    omega   - estimated mode center frequencies
    
    
    */
    
    
    //-------------------Preparations
    
    // Period and sampling frequency of input signal

    save_T = length(signal);
    fs = 1/save_T;
    
    //Extend the signal by mirroring
    
    T = save_T;
    f_mirror(1:T/2) = signal(T/2:-1:1);
    f_mirror(T/2+1:3*T/2) = signal;
    f_mirror(3*T/2+1:2*T) = signal(T:-1:T/2+1);
    f = f_mirror;
    
    // Time Domain 0 to T (of mirrores signal)
    T = length(f);
    t = (1:T)/T;
    
    //Spectral Domain Discretization
    freqs = t-.5-1/T; //(what's this?)}

    
    //Maximum number of iterations allowed

    //N = 1500;


    
    //For future generalizations: individual alpha for each mode
    Alpha = alpha* ones(1, K);
    //Alpha = alpha;
    
    //Construct and center f_hat (I NEED TO CHECK THIS PART IN THE DOCS) (It's Ok)
    f_hat = fftshift(fft(f));
    f_hat_plus = f_hat;
    f_hat_plus(1:T/2) = 0;
    
    
   
    
    
    
    //Matrix keeping track of every iterant (could be discarded)

    u_hat_plus = zeros(2, T, K);
    
    //Initialization of omega_k

    omega_plus = zeros(2, K);
    
    switch init
    case 1
        for i = 1:K
            omega_plus(1, i) = (.5/K)*(i-1);
        end
    case 2
        omega_plus(1,:) = gsort(exp(log(fs) + (log(.5)-log(fs))*rand(1, K)));
    otherwise
        omega_plus(1,:) = 0;
    end
    
    //If DC mode imposed, set its omega to 0
    if DC then
        omega_plus(1,1) = 0;
    end
    
    //start with empty dual variables
    lambda_hat = zeros(2, T);
    
    //other inits
    
    uDiff = tol + %eps; //update step
    n = 1; //loop counter
    sum_uk = 0; // accumulator
    
    

    // ----------  main loop for iterative updates
  
    while (uDiff > tol & n< N) //not converged and below iteration limit

        u_hat_plus(2, :, :) = u_hat_plus(1, :, :);
        omega_plus(2, :) = omega_plus(1, :);
        lambda_hat(2,:) = lambda_hat(1, :);

        
        //update first mode acumulator
        k = 1;
        sum_uk = u_hat_plus(2, :, K) + sum_uk - u_hat_plus(2, :, 1);
        
        //update spectrum of first mode trhough wiener filter of residuals
        u_hat_plus(1, :, k) =(f_hat_plus - sum_uk - lambda_hat(2,:)/2)./(1+Alpha(1,k)*(freqs - omega_plus(2,k)).^2);
        
        //update first omega if not held at 0
        if ~DC then
            omega_plus(1,k) = (freqs(T/2+1:T)*(abs(u_hat_plus(1, T/2+1:T, k)).^2)')/sum(abs(u_hat_plus(1,T/2+1:T,k)).^2);
        end
        
        //update of any other mode
        for k = 2:K
           
           //accumulator
           sum_uk = u_hat_plus(1,:,k-1) + sum_uk - u_hat_plus(2,:,k);
           
           //mode spectrum
           u_hat_plus(1,:,k) = (f_hat_plus - sum_uk - lambda_hat(2,:)/2)./(1+Alpha(1,k)*(freqs - omega_plus(2,k)).^2); //this is strange. there is a minus there.
           
           //center frequencies
           omega_plus(1,k) = (freqs(T/2+1:T)*(abs(u_hat_plus(1, T/2+1:T, k)).^2)')/sum(abs(u_hat_plus(1,T/2+1:T,k)).^2); //it seems ok, but we need to check.
           
        end
        //dual ascent
        lambda_hat(1, :) = lambda_hat(2, :) + tau*(sum(u_hat_plus(1, :, :), 3) - f_hat_plus); //there is a missing minus sign here.
        
        n = n + 1; //loop counter
        
        //check if convergent
        uDiff = %eps;
        
        for i = 1:K

            uDiff = uDiff + 1/T * (u_hat_plus(1, :, i) - u_hat_plus(2, :, i)) * conj((u_hat_plus(1, :, i)-u_hat_plus(2, :, i)))';
            
            //last line does not agree with the papers. See Zosso2014 page 536 for example.
            // This next line is an attempt to fix the tolerance criteria. Observe that it is computationally incredibly more expensive.
            
            //uDiff = uDiff + ((u_hat_plus(n, :, i) - u_hat_plus(n-1, :, i)) * conj((u_hat_plus(n, :, i)-u_hat_plus(n-1, :, i)))' )/(u_hat_plus(n, :, i)* conj(u_hat_plus(n, :, i)');
        end
        uDiff = abs(uDiff);
        
    end
    
 
    //Postprocessing and cleanup
    
    
    omega = omega_plus(1, :);
    
    //signal reconstruction
    u_hat = zeros(T, K);
    u_hat((T/2+1):T, :) = squeeze(u_hat_plus(1, (T/2+1):T, :));
    u_hat((T/2+1):-1:2, :) = squeeze(conj(u_hat_plus(1, (T/2+1):T, :)));
    u_hat(1, :) = conj(u_hat($, :));
    
    u = zeros(K, T);
    
    for k = 1:K
        u(k, :) = real(ifft(ifftshift(u_hat(:, k))));
    end
    
    //removemirror part
    
    u = u(:, T/4+1:3*T/4);
    
    //recompose spectrum
    clear u_hat
    for k = 1:K
        u_hat(:, k) = fftshift(fft(u(k, :)))';
    end
    
endfunction
