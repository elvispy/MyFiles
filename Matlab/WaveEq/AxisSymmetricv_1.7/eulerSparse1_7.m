function [Eta_k_prob, u_k_prob, z_k_prob, v_k_prob, P_k_prob, errortan] = ...
    eulerSparse1_6(newCPoints, mCPoints, Eta_k, u_k, z_k, v_k, ~, dt, ...
    dr, Fr, ~, Ntot, AA)
    if newCPoints < 0 || newCPoints > mCPoints
        errortan = Inf;
        Eta_k_prob = NaN * sparse(length(Eta_k), 1);
        u_k_prob = NaN * sparse(length(u_k), 1);
        z_k_prob = NaN;
        v_k_prob = NaN;
        P_k_prob = NaN;
    else

        %% Building R and R_prime
        R = [zeros(Ntot - newCPoints, 1); (-Fr * dt) * ones(Ntot, 1); 0 ; -Fr * dt];
        for ii = (Ntot - newCPoints + 1):Ntot
            R(ii) = R(ii) + 2 * dt;
        end
        f = @(x) sqrt(1-dr^2 * x.^2);
        residual_1 = AA{newCPoints + 1}.residual_1;
        if newCPoints > 0
            residual_1(Ntot + newCPoints + 1, end) = ...
                dt * residual_1(Ntot + newCPoints + 1, end); 
        end
        R_prime = residual_1 * (f(0:(newCPoints-1))');
        R_prime = R_prime((newCPoints+1):end);


        %% Solving the system
        x = [Eta_k;u_k; z_k;v_k]; x = x((newCPoints+1):end);
        results = (dt * AA{newCPoints + 1}.A + AA{newCPoints + 1}.ones) ...
            \(x + R + R_prime);

        z_k_prob = results(end-1);
        v_k_prob = results(end);
        Eta_k_prob = [z_k_prob - (f(0:(newCPoints-1))'); results(1:(Ntot-newCPoints))];

        u_k_prob = v_k_prob * ones(newCPoints, 1);
        u_k_prob = [u_k_prob; results((Ntot-newCPoints + 1):(2*Ntot - 2 * newCPoints))];
        P_k_prob = results((2*Ntot - 2 * newCPoints + 1):(2*Ntot - newCPoints));


        %% Calculating errortan
        errortan = 0;
        
        if newCPoints ~= 0
            g = @(x) x/sqrt(1-x^2); ppt = (newCPoints-1)*dr + dr/2;
            approximateSlope = (Eta_k_prob(newCPoints+1)-Eta_k_prob(newCPoints))/dr;
            exactSlope = g(ppt);
            errortan = abs(atan(approximateSlope) - atan(exactSlope));
        end
        
        % Check whether the sphere and the membrane intersect
        for ii = (newCPoints + 1):mCPoints
            if Eta_k_prob(ii) > z_k_prob - f(ii-1)
                errortan = Inf;
                break;
            end
        end % end for
    end %end main if
end % end main function