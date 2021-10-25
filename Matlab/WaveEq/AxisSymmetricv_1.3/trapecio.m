function [Eta_k_prob, u_k_prob, z_k_prob, v_k_prob, P_k_prob, errortan] = ...
    trapecio(newCPoints, mCPoints, Eta_k, u_k, z_k, v_k, P_k, dt, ...
    dr, Fr, Mr, Ntot)
    
    %% Documentation
    % This function solves the system Ax = By + z to calculate the position
    % of the sphere and the elastic band, with pressure included
    % -)newCpoints = Number of pressure contact points at time k+1
    % -)mCPoints = Maximum number of contact points.
    % -)Eta_k = Vector of vertical displacement of the rope
    % -)u_k = vector of vertical velocities of the rope
    % -)z_k = vertical position of the center of the ball
    % -)v_k = vertical velocity of the center of the ball
    % -)P_k = vector of pressures in the last time step. Only 
    % non-trivial points are inside
    % -)delt, delx = Temporal and spatial grid minimum difference,
    % respectively
    % -)Ntot = Number of spatial points in half the rope
    % -)constants = a list with the constants needed for the program,
    % containing:
    %     -)Fr = (mu * R * g)/Tm, Frobenius number
    %     -)Ma = mu * R^2 / m
    %LHS of the PDE
    %Outputs:
    % -)Eta_k_prob = Vector of vectical position of the band
    % -)u_k_prob = vector of vertical velocities of the band
    % -)z_k_prob = Position of the center of the sphere
    % -)v_k_prob = Vertical velocity of the center of the ball
    % -)P_k_prob = pressures applied against the ball.
    % errortan = Error associated to the angle after contact point
    

    if newCPoints < 0 || newCPoints > mCPoints
        errortan = Inf;
        Eta_k_prob = NaN * zeros(size(Eta_k));
        u_k_prob = NaN * zeros(size(u_k));
        z_k_prob = NaN;
        v_k_prob = NaN;
        P_k_prob = NaN;
       
    else
        %% Building A
        %A will have 20 parts, corresponding to the 5 variables and 4
        %equations 
        
        %First column block (Eta_k)
        %Lets build A'
        A_prime = diag( dt/(dr^2) * ones(Ntot, 1)); %diagonal terms are equal
        A_prime(1, 1) =  (2*dt)/(dr^2);
        A_prime(1, 2) = -(2*dt)/(dr^2);
        for i = 2:(Ntot-1)
             A_prime(i, i-1)= -(dt)/(2*dr^2) * (2*i-3)/(2*i-2);
             A_prime(i, i+1)= -(dt)/(2*dr^2) * (2*i-1)/(2*i-2);
        end
        %A_prime(Ntot, Ntot-1) = -(delt)/(2*delr^2) * (2*Ntot-1)/(2*Ntot-2); 
        A_prime(Ntot, Ntot - 1) = -(dt)/(2*dr^2) * (2*Ntot-3)/(2*Ntot-2);
        
        A_1 = [eye(Ntot); A_prime; zeros(2, Ntot)];
        
        C1 = A_1(:, 1:newCPoints);
        A_1 = A_1(:, (newCPoints+1):end); %First columns discarded
        
        %Second colum block (u_k)
        A_2 = [-dt/2 * eye(Ntot); eye(Ntot); zeros(2, Ntot)];
        
        %Third column block (P_k)
        %Building the integration vector
        S = int_vector(newCPoints);
        S = - (dt/2 * Mr * dr^2) * S;
        
        A_3 = [zeros(Ntot, newCPoints); ...
              (dt/2) * eye(newCPoints); ...
              zeros(Ntot-newCPoints+1, newCPoints);...
              S];
          
          
        %Now last columns (z_k and v_k)
        A_4 = [sum(C1, 2) zeros(2*Ntot + 2, 1)];
        A_4(end-1, 1) = 1;
        A_4(end-1, 2) = -dt/2;
        A_4(end, 2) = 1;
        
        A = [A_1, A_2, A_3, A_4];
        
        
        %% Building B
        
        %First column-block (Eta_k)
        B_1 = [eye(Ntot); -A_prime; zeros(2, Ntot)];
        
        %Second column block (u_k)
        B_2 = [(dt/2) * eye(Ntot); eye(Ntot); zeros(2, Ntot)];
        
        %third block (P_k)
        oldCPoints = length(P_k);
        
        B_3 = [zeros(Ntot, Ntot); - dt/2 * eye(Ntot); zeros(1, Ntot)];
        
        B_3 = B_3(:, 1:oldCPoints);
        %Integration vector
        S =  (dt/2) * Mr * dr^2 * int_vector(oldCPoints);
        
        B_3 = [B_3; S];
        
        %Fourth column-block (z_k and v_k)
        B_4 = [zeros(2*Ntot, 2); [1 dt/2; 0 1]]; 
        
        B = [B_1 B_2 B_3 B_4];
        
        %% Building R and R_prime
        
        %change this if your dont want to take into accoutn gravity
        %R = [zeros(Ntot, 1); -Fr * delt * ones(Ntot, 1); 0 ; -Fr * delt]; %with gravity
        R = zeros(2*Ntot + 2, 1);
        R(end) = -Fr * dt;
        
        
        f = @(x) sqrt(1-(dr^2 * x .* x));
        
        R_prime = C1 * (f(0:(newCPoints-1))');
        
        %% Building Wk and solving the system
        
        Wk = [Eta_k; u_k; P_k; z_k; v_k];
        %disp(B*Wk + R + R_prime);
        x = A\(B*Wk + R + R_prime);
 
        %Extracting vectors from solution
        z_k_prob = x(end - 1);
        v_k_prob = x(end);
        
        Eta_k_prob = z_k_prob - f(0:(newCPoints - 1))';
        Eta_k_prob = [Eta_k_prob; x(1:(Ntot - newCPoints))];
        
        u_k_prob = x((Ntot - newCPoints + 1):(2*Ntot - newCPoints));
        P_k_prob = x((2 * Ntot - newCPoints + 1):(2*Ntot));
        
        
        assert(size(Eta_k_prob, 1) == Ntot);
        assert(size(u_k_prob, 1) == Ntot);
        assert(size(P_k_prob, 1) == newCPoints);
        assert(size(x, 1) == 2*Ntot + 2);
        
        %% Calculating errortan
        errortan = 0;
        if newCPoints ~= 0
   
            %tanSphere is the perfect tangent at a point near the last
            %contact point
            g = @(x) x/sqrt(1-x^2); ppt = (newCPoints-1)*dr + dr/2;
            approximateSlope = (Eta_k_prob(newCPoints+1)-Eta_k_prob(newCPoints))/dr;
            exactSlope = g(ppt);
            errortan = abs(atan(approximateSlope) - atan(exactSlope));
        end
        
        %Distance vector of every point on the fiml to the sphere
        idx = ceil(1/dr);
        dist = (Eta_k_prob(1:(idx+1)) - z_k_prob).^2 + (dr * (0:idx)').^2;

        if any(dist < 1 - 1e-9)
            errortan = Inf;
        end
    
    end %end outer if
end %end function definition


%% Integration vector definition
function S = int_vector(n)
    %THe integration vector without dhe dr^2 factor
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