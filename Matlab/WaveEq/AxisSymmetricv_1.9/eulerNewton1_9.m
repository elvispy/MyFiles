%eulerNewton1_9 Solve next step of motion with dt time step.
%   This function will solve the motion of the object with dt time step and
%   euler method on temporal variable. Since the PDE is nonlinear, Newton
%   Method will be used to find the solution.
%   

function [Eta_k_prob, u_k_prob, z_k_prob, v_k_prob, P_k_prob, errortan] = ...
    eulerNewton1_9(newCPoints, mCPoints, Eta_k, u_k, z_k, v_k, ~, dt, ...
    dr, Fr, ~, Ntot, Jacobian, D)

    TRESHOLD = 1e-10; % Treshold to determine if solution converged
    if newCPoints < 0 || newCPoints > mCPoints
        errortan = Inf;
        Eta_k_prob = NaN * sparse(length(Eta_k), 1);
        u_k_prob = NaN * sparse(length(u_k), 1);
        z_k_prob = NaN;
        v_k_prob = NaN;
        P_k_prob = NaN;
    else

        %% Building R and R_prime
        R = [zeros(Ntot - newCPoints, 1); (-Fr * dt) * ones(Ntot, 1); 0; -Fr * dt];
        for ii = (Ntot - newCPoints + 1):Ntot
            R(ii) = R(ii) + 2 * dt; % Exact curvature on contact points!
        end
        f = @(x) sqrt(1-dr^2 * x.^2);
        residual_1 = Jacobian{newCPoints + 1}.residual_1;
        if newCPoints > 0
            residual_1(Ntot + newCPoints + 1, end) = ...
                dt * residual_1(Ntot + newCPoints + 1, end); 
        end
        R_prime = residual_1 * (f(0:(newCPoints-1))');
        R_prime = R_prime((newCPoints+1):end);
        
        
        coord_filas = zeros(Ntot + 1, 1);
        coord_columnas = zeros(Ntot + 1, 1);
        % Indexes for v block( second equation, KM condition)
        coord_filas(1:newCPoints) = ...
            (Ntot - newCPoints + 1):Ntot;
        coord_columnas(1:newCPoints) = ...
            (2*Ntot - newCPoints + 2) * ones(newCPoints, 1);

        % Indexes for u block (second equation)
        coord_filas((newCPoints + 1):Ntot) = ...
            (Ntot + 1):(2*Ntot - newCPoints);
        coord_columnas((newCPoints + 1):Ntot) = ...
            (Ntot - newCPoints + 1):(2*Ntot - 2*newCPoints);
        
        
        coord_filas(Ntot + 1) = 2*Ntot - newCPoints + 2; % to make sparse matrix  of correct size
        coord_columnas(Ntot + 1) = 2*Ntot - newCPoints + 2; % to make sparse matrix  of correct size
        

        %% Solving the system
        W = [Eta_k((newCPoints+1):end); u_k((newCPoints+1):end); 2*ones(newCPoints, 1); z_k;v_k]; % we cut the first equations
        independent_term = [Eta_k((newCPoints+1):end); u_k; z_k;v_k];
        A = ( ...
            dt * Jacobian{newCPoints + 1}.A  + ...
            Jacobian{newCPoints + 1}.ones);
        A_full = (A + sparse(coord_filas, coord_columnas, [2*dt*D*abs(u_k); 0]));
        % We will need the nonlinear part of the function
        NonLinearContribution = [zeros(Ntot - newCPoints, 1); dt * D * (u_k.*abs(u_k)); 0; 0];
        
        next_iteration = W -  A_full\(A*W + NonLinearContribution - R - R_prime - independent_term);
        
        while norm(next_iteration - W) >= TRESHOLD
            W = next_iteration;
            previous_velocity = [W(end) * ones(newCPoints, 1); ...
                W((Ntot - newCPoints + 1):(2*Ntot - 2*newCPoints))];
            % We will need the nonlinear part of the function
            NonLinearContribution = [zeros(Ntot - newCPoints, 1); ...
                dt * D * (previous_velocity.*abs(previous_velocity)); 0; 0];
            next_iteration = W -  (A + sparse(coord_filas, coord_columnas, ...
                [2*dt*D*abs(previous_velocity); 0])) ...
                \(A*W + NonLinearContribution - R - R_prime - independent_term);
        end

        %% Post Processing
        
        z_k_prob = next_iteration(end-1);
        v_k_prob = next_iteration(end);
        Eta_k_prob = [z_k_prob - (f(0:(newCPoints-1))'); next_iteration(1:(Ntot-newCPoints))];

        u_k_prob = v_k_prob * ones(newCPoints, 1);
        u_k_prob = [u_k_prob; next_iteration((Ntot - newCPoints + 1):(2*Ntot - 2 * newCPoints))];
        P_k_prob = next_iteration((2*Ntot - 2 * newCPoints + 1):(2*Ntot - newCPoints));


        %% Calculating errortan
        errortan = 0;
        
        if newCPoints ~= 0
            g = @(x) x/sqrt(1-x^2); ppt = (newCPoints-1)*dr + dr/2;
            approximateSlope = (Eta_k_prob(newCPoints+1)-Eta_k_prob(newCPoints))/dr;
            exactSlope = g(ppt);
            errortan = (exactSlope) - (approximateSlope);
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