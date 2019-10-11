// find the maginal Hilbert Spectrum
function [A, F] = mhs(HS,freqs,flag,fres,fs)
    //-------------------------------JDSA---------------------------------------
    // A is the sum of the contribution of each frequency component in the freq
    // vector for all time points.
    // 
    // F is the vector with the frequency axis, use it as x axis to plot the mhs
    // 
    // HS is the gilbert spectrum amplitudes, one imf per coulmn
    //
    // freqs is the instantaneous frequency, one instantaneous frequency per
    // column
    //
    // Flag (1 or 0) flag=1 is used to quantize the values of the instantaneous 
    // frequency, then values inside a unit of the resolution ar counted as as
    // the same frequency. for instance if you have 2 frequencies 10,34 and 
    // 10,45 and the resolution is .25, those 2 frequencies are counted each one
    // as 10,5 and the mhs sum the amplitude related to each frequency as if 
    // they belong to the same frequency value, this produce smooted graphs
    // fs is the sample rate of the original signal.
    // flag = 0 dont quantize the vectors of instantaneous frequency
    //NOTE:TAKE ON COUNT THAT THE FREQUENCY AXIS IS NOT EQUALLY ESPACED, FROM
    //THE INSTANTANEOUS FREQUENCY SOME VALUES OF F ARE NEVER REACHED, THE IF CAN
    //CHANGE FOR INSTANCE FROM 12.5 TO 14.5 AND 13 AND 13.5 DO NOT APPEAR AS 
    //HAVING 0 (ZERO) CONTRIBUTION
    //
    HS = reshape(HS,1,[])';
    freqs = reshape(freq,1,[])';
    if flag==1
        if ( or([fres > 1 , fres <= 0 ]) ) 
            disp('The value of resolution should be > 0 and <= 1Hz')
            return
        end
        fraction = log(1/fres)/log(2);
        wordlength = floor(log(((fs/2-fraction)*2^(fraction))+1)/log(2) + 0.5);
        q = quantizer('ufixed', 'nearest', 'saturate', [wordlength fraction]);
        freqs = quantize(q,freqs);
    end
    i=1;
    while isempty(freqs)==0
        indx = find(freqs==freqs(1));
        ftemp(i)= freqs(1);
        Atemp(i)=sum(HS(indx));
        freqs(indx)=0;
        HS(indx)=0;
        freqs = freqs(freqs~=0);
        HS=HS(HS~=0);
        i = i + 1;
    end
    [F indx] = sort(ftemp);
    A = Atemp(indx);
endfunction
