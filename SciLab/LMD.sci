function [PFs] = LMD(x)
    clc;
    
    N = length(x);
    A = ones(1, N);
    PF = [];
    aii = 2*A;
    
    while (%T)
        
        si = x;
        a = 1;
        while (%T)
            h = si;
            maxVec = [];
            minVec = [];
            
            //look for max and min point
            for i = 2:N-1
                 if (and([h(i-1) < h(i) , h(i) > h(i+1)]))
                      maxVec  = [maxVec i];
                 end //end first if
                 if and([h(i-1) > h(i) , h(i) < h(i+1)])
                     minVec = [minVec i ];
                 end //end second if
            end //end for
            
            //check if it is residual
            if ( length(maxVec) + length(minVec)) < 2
                break;
            end //end third if
            
            
            //handle end point
            lenmax = length(maxVec);
            lenmin = length(minVec);
            
            //left end point
            if (h(1) > 0)
                if(maxVec(1) < minVec(1))
                    yleft_max = h(maxVec(1));
                    yleft_min = -h(1);
                else
                    yleft_max = h(1);
                    yleft_min = h(minVec(1));
                end //end first inner if
            else
                if ( maxVec(1) < minVec(1))
                    yleft_max = h(maxVec(1));
                    yleft_min = h(1);
                else
                    yleft_max = -h(1);
                    yleft_min = h(minVec(1));
                end //end second ineer if
            end //end outer if
            
            //right end point
            if h(N) > 0
                if (maxVec(lenmax) < minVec(lenmin))
                    yright_max = h(N);
                    yright_min = h(minVec(lenmin));
                else
                    yright_max = h(maxVec(lenmax));
                    yright_min = -h(N);
                end //end first inner for
            else
                if (maxVec(lenmax) < minVec(lenmin))
                    yright_max = -h(N);
                    yright_min = h(minVec(lenmin));
                else
                    yright_max = h(maxVec(lenmax));
                    yright_min = h(N);
                end //end second inner if
            end //end outer if
            
            
            maxEnv = interp(1:N, [1 maxVec N], [yleft_max h(maxVec) yright_max], splin([1 maxVec N], [yleft_max h(maxVec) yright_max]));
            minEnv = interp(1:N, [1 minVec N], [yleft_min h(minVec) yright_min], splin([1 minVec N], [yleft_min h(minVec) yright_min]));
            
            mm = (maxEnv + minEnv)/2;
            aa = abs(maxEnv-minEnv)/2;
            
            mmm = mm;
            aaa = aa;
            
            preh = h;
            h = h-mmm;
            si = h./aaa;
            a = a.*aaa;
            
            aii = aaa;
            
            B = length(aaa);
            C = ones(1, B);
            bb = norm(aaa-C);
            if (bb < 1000)
                break;
            end 
            
  
        end //end first while
    
        pf = a.*si;
        if exists("PFs") == 1
            PFs = [PFs; pf];
        else
            PFs = pf;
        end
        bbb = length(maxVec) + length(minVec);
        //check if it is residual
        if ((length(maxVec) + length(minVec)) < 20)
            break;
        end
    
        x = x - pf;
    end //end second while

endfunction
