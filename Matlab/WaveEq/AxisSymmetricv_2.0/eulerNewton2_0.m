%eulerNewton2_0 Solve next step of motion with dt time step.
%   This function will solve the motion of the object with dt time step and
%   euler method on temporal variable. Since the PDE is nonlinear, Newton
%   Method will be used to find the solution. This implementation uses full
%   curvature and simulates vacuum conditions.
%   

function [Eta_k_prob, u_k_prob, z_k_prob, v_k_prob, P_k_prob, errortan] = ...
    eulerNewton2_0(newCPoints, mCPoints, Eta_k, u_k, z_k, v_k, ~, dt, ...
    dr, Fr, ~, Ntot, Jacobian, ~)

    TRESHOLD = 1e-8; % Treshold to determine if solution converged
    
    % Input checking
    if newCPoints < 0 || newCPoints > mCPoints
        errortan = Inf;
        Eta_k_prob = NaN * sparse(length(Eta_k), 1);
        u_k_prob = NaN * sparse(length(u_k), 1);
        z_k_prob = NaN;
        v_k_prob = NaN;
        P_k_prob = NaN;
    else

        %% Building R and R_prime
        gravityInfluence = [zeros(Ntot - newCPoints, 1); (-Fr * dt) * ones(Ntot, 1); 0; -Fr * dt];
%         for ii = (Ntot - newCPoints + 1):Ntot
%             gravityInfluence(ii) = gravityInfluence(ii) + 2 * dt; % Exact curvature on contact points!
%         end
        f = @(x) sqrt(1-dr^2 * x.^2);
        % These are the terms related to the relation eta_i = z_k - f(i)
        residual_1 = Jacobian{newCPoints + 1}.residual_1;
        
        %if newCPoints > 0
        %    residual_1(Ntot + newCPoints + 1, end) = ...
        %        dt * residual_1(Ntot + newCPoints + 1, end); 
        %end
        sphereHeightTerm = residual_1 * (f(0:(newCPoints-1))');
        sphereHeightTerm = sphereHeightTerm((newCPoints+1):end);
        
        
        %% When using air, uncomment this part
%         % Lets index on 
%         coord_filas = zeros(Ntot + 1, 1);
%         coord_columnas = zeros(Ntot + 1, 1);
%         % Indexes for v block( second equation, KM condition)
%         coord_filas(1:newCPoints) = ...
%             (Ntot - newCPoints + 1):Ntot;
%         coord_columnas(1:newCPoints) = ...
%             (2*Ntot - newCPoints + 2) * ones(newCPoints, 1);
% 
%         % Indexes for u block (second equation)
%         coord_filas((newCPoints + 1):Ntot) = ...
%             (Ntot + 1):(2*Ntot - newCPoints);
%         coord_columnas((newCPoints + 1):Ntot) = ...
%             (Ntot - newCPoints + 1):(2*Ntot - 2*newCPoints);
%         
%         coord_filas(Ntot + 1) = 2*Ntot - newCPoints + 2; % to make sparse matrix  of correct size
%         coord_columnas(Ntot + 1) = 2*Ntot - newCPoints + 2; % to make sparse matrix  of correct size
        

        %% Solving the system
        W = [Eta_k((newCPoints+1):end); u_k((newCPoints+1):end); 2*ones(newCPoints, 1); z_k;v_k]; % we cut the first equations
        independent_term = [Eta_k((newCPoints+1):end); u_k; z_k;v_k];
        A = ( ...
            dt * Jacobian{newCPoints + 1}.A  + ...
            Jacobian{newCPoints + 1}.ones);
        A_full = (A - dt * JacobianCurvature(Eta_k, z_k, dr, newCPoints));
        % We will need the nonlinear part of the function
        %functionAppliedToData = [zeros(Ntot - newCPoints, 1); dt * D * (u_k.*abs(u_k)); 0; 0];
        
        next_iteration = W -  A_full\(A*W - dt * curvature(Eta_k, dr) - gravityInfluence - sphereHeightTerm - independent_term);
        
        while norm(next_iteration - W) >= TRESHOLD
            W = next_iteration;
            previousz_k = W(end-1);
            previous_Etak = [previousz_k - (f(0:(newCPoints-1))'); W(1:(Ntot-newCPoints))];
            %previous_velocity = [W(end) * ones(newCPoints, 1); ...
            %    W((Ntot - newCPoints + 1):(2*Ntot - 2*newCPoints))];
            % We will need the nonlinear part of the function
            %NonLinearContribution = [zeros(Ntot - newCPoints, 1); ...
            %    dt * D * (previous_velocity.*abs(previous_velocity)); 0; 0];
            next_iteration = W -  (A - dt * JacobianCurvature(previous_Etak, previousz_k, dr, newCPoints))  ...
                \(A*W - dt * curvature(previous_Etak, dr) - gravityInfluence - sphereHeightTerm - independent_term);
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

function fc = curvature(eta, dr, newCPoints)
    % This function computes the contribution of the full curvature 
    % eta is a vector which has all the information about the position of the membrane
    % and dr is the spatial step
    n = length(eta); Ntot = n - 1 + newCPoints;
    %fc = zeros(1, n); % we define the vector to be returned

    fc = (2 * dr^2) * ones(newCPoints, 1);
    eta = [eta, 0];
    diffs2 = zeros(n-1, 1);
    for ii = 2:n
        diffs2(ii - 1) = eta(ii+1) - eta(ii-1);
    end
    num1 = diff(eta, 2);
    AUX = (1+ (diffs2/2*dr).^2);
    fc = [fc; num1./(AUX.^(3/2)) ...
        + diffs2 / (2* (newCPoints:(n-2+newCPoints)) .* sqrt(AUX))]/dr^2;
    if newCPoints == 0
        fc(1) = dr^2 * (4*eta(2) - 4 * eta(1));
    end
    fc = [zeros(n - 1 - newCPoints, 1); fc; zeros(newCPoints  + 2)];
    % assert(length(fc) == 2* n  - newCPoints + 2);
end
function curvatureMatrix = JacobianCurvature(eta, zk, dr, newCPoints)
    % THis function calculates the jacobian of the non lineal system
    % (which happens to be associated only to curvature
    n = length(eta);
    sizze = n - newCPoints;
    
    new_etas = [eta((newCPoints + 1):end); 0];
    if newCPoints > 0
        new_etas = [zk - sqrt(1 - dr^2 * (newCPoints - 1)^2); new_etas];
    end
    A1 = auxiliaryfunction1(new_etas, dr);
    A2 = auxiliaryfunction2(new_etas, dr, newCPoints);
    A3 = auxiliaryfunction3(new_etas, dr);
    A4 = auxiliaryfunction4(new_etas, dr, newCPoints);
   
    mainDiagonal = 2 * A1;
    upperDiagonal = A1 + A2 - A3 - A4; 
    lowerDiagonal = A1 - A2 + A3 + A4;
    if newCPoints == 0
        lowerDiagonal = [0; lowerDiagonal];
        mainDiagonal = [-4; mainDiagonal];
        upperDiagonal = [4; upperDiagonal];
    end
    curvatureMatrix = sparse([(n + 1):(n + sizze), (n + 1):(n + sizze-1), (n + 2):(n + sizze), n + 1], ...
        [1:sizze, 2:sizze, 1:(sizze-1), 2*n - 2 * newCPoints + 1], ...
        [mainDiagonal, upperDiagonal(1:(end-1)), ...
        lowerDiagonal(2:end), lowerDiagonal(1)], 2 * n - 2 * newCPoints + 2, 2 * n - 2 * newCPoints + 2);
    %zkterm = lowerDiagonal(1);
end

function val = auxiliaryfunction1(new_etas, dr)
    % New etas has all the information about the membrane to calculate the
    % curvature. (the first elements is possibly a function of z_k and the
    % last element is zero.
    n = length(new_etas);
    diffs2 = zeros(n-2, 1);
    for ii = 2:(n - 1)
        diffs2(ii - 1) = new_etas(ii + 1) - new_etas(ii - 1);
    end
     AUX = (1+ (diffs2/2*dr).^2);
     val = 1/(dr^2 * AUX.^(3/2));
end


function val = auxiliaryfunction2(new_etas, dr, newCPoints)
    n = length(new_etas);
    diffs2 = zeros(n-2, 1);
    for ii = 2:(n - 1)
        diffs2(ii - 1) = new_etas(ii+1) - new_etas(ii - 1);
    end
    AUX = (1+ (diffs2/2*dr).^2);
    if newCPoints == 0
        newCPoints = 1;
    end
    val = 1/(2 * dr^2 *(newCPoints:(n - 3  + newCPoints)) .* sqrt(AUX));
end

function val = auxiliaryfunction3(new_etas, dr)
    n = length(new_etas);
    diffs = zeros(1, n - 2);
    for ii = 2:(n - 1)
        diffs(ii - 1) = new_etas(ii + 1) - new_etas(ii - 1);
    end
    NUM = 6*diffs .* diff(new_etas, 2);
    DEN = (1+ (diffs/2*dr).^2);
    val = NUM/(8* dr^4 * DEN.^(5/2));
end


function val = auxiliaryfunction4(new_etas, dr, newCPoints)
    n = length(new_etas);
    diffs = zeros(1, n - 2);
    for ii = 2:(n - 1)
        diffs(ii-1) = new_etas(ii+1) - new_etas(ii - 1);
    end
    NUM = diffs.^2;
    DEN = (1+ (diffs/2*dr).^2);
    val = NUM/(8* dr^4 * (newCPoints:(n - 3 + newCPoints)) .* DEN.^(3/2));
end