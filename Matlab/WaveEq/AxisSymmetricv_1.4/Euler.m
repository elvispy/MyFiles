function [Eta_k_prob, u_k_prob, z_k_prob, v_k_prob, P_k_prob, errortan] = ...
    Euler(newCPoints, mCPoints, Eta_k, u_k, z_k, v_k, ~, dt, ...
    dr, Fr, Mr, Ntot)
    if newCPoints < 0 || newCPoints > mCPoints
        errortan = Inf;
        Eta_k_prob = NaN * zeros(size(Eta_k));
        u_k_prob = NaN * zeros(size(u_k));
        z_k_prob = NaN;
        v_k_prob = NaN;
        P_k_prob = NaN;
    else
        %% Building A

        %First column block (Eta_k)
        A_prime = 2*eye(Ntot);
        A_prime(1, 1) = 4;
        A_prime(1, 2) = -4;
        for i = 2:Ntot
           A_prime(i, i-1) = -(2*i-3)/(2*i-2);
           if i < Ntot
               A_prime(i, i+1) = -(2*i-1)/(2*i-2);
           end
        end
        A_prime = (dt / dr^2) * A_prime;
        A_prime(1:newCPoints, :) = zeros(newCPoints, Ntot);

        I_M = eye(Ntot);
        A_1 = [I_M; A_prime;zeros(2, Ntot)];
        residual_1 = A_1(:, 1:newCPoints);
        A_1 = A_1(:, (newCPoints+1):end);

        %Second colum block (u_k)
        A_2 = [-dt* I_M; I_M; zeros(2, Ntot)];
        residual_2 = A_2(:, 1:newCPoints);
        A_2 = A_2(:, (newCPoints+1):end);

        %Third column block (P_k)
        A_3 = [zeros(Ntot, Ntot); dt*I_M; zeros(1, Ntot)];
        A_3 = [A_3(:, 1:newCPoints); -(dr^2 * dt * Mr) * int_vector(newCPoints)];

        %Now last columns (z_k and v_k)
        A_4 = [sum(residual_1, 2), sum(residual_2, 2)];
        A_4(end, end) = 1;
        A_4(end-1, end-1) = 1;
        A_4(end-1, end) = -dt;

        A = [A_1, A_2, A_3, A_4];
        A = A((newCPoints + 1):end, :);


        %% Building R and R_prime
        R = [zeros(Ntot - newCPoints, 1); (-Fr * dt) * ones(Ntot, 1); 0 ; -Fr * dt];
        for ii = (Ntot - newCPoints + 1):Ntot
            R(ii) = R(ii) + 2 * dt;
        end
        f = @(x) sqrt(1-dr^2 * x.^2);

        R_prime = residual_1 * (f(0:(newCPoints-1))');
        R_prime = R_prime((newCPoints+1):end);


        %% Solving the system
        x = [Eta_k;u_k; z_k;v_k]; x = x((newCPoints+1):end);
        results = A\(x + R + R_prime);

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


function S = int_vector(n)
    % The integration vector without dhe dr^2 factor that goes into the
    % Pk block
    if n == 0
        S = [];
    elseif n == 1
        S = [pi/12];
    else
        S = (pi) * ones(1, n);
        S(1) = 1/3 * S(1);
        for i = 2:(n-1)
            S(i) = 2*(i-1) * S(i);
        end
        S(n) = (3/2 * (n - 1) - 1/4) * S(n);
    end
end
