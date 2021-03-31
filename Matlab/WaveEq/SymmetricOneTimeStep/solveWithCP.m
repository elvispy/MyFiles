function [Eta_k_prob, u_k_prob, z_k_prob, v_k_prob, P_k_prob, errortan] = ...
    solveWithCP(newCPoints, mCPoints, Eta_k, u_k, z_k, v_k, P_k, delt, ...
    delx, Ntot, Fr, Ma)
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
    %     -)Fr = Tm / (mu * R * g), Frobenius number
    %     -)Ma = mu * R / m
    %LHS of the PDE
    
    %Outputs:
    
    % -)Eta_k_prob = Vector of vectical position of the band
    % -)u_k_prob = vector of vertical velocities of the band
    % -)z_k_prob = Position of the center of the sphere
    % -)v_k_prob = Vertical velocity of the center of the ball
    % -)P_k_prob = pressures applied against the ball.
    % errortan = Error associated to the angle after contact point
    
    if newCPoints < 0 || newCPoints > mCPoints
        %So if we're asking for smth wrong arguments
        errortan = Inf;
        Eta_k_prob = zeros(size(Eta_k));
        u_k_prob = zeros(size(u_k));
        z_k_prob = 0;
        v_k_prob = 0;
        P_k_prob = 0;
    else
        %%
        %First, lets construct the matrix A. A will have 20 parts,
        %corresponding to the 5 variables and 4 equations. I will build the
        %parts in column order, from left to right

        %First Column block (Eta_k)
        C = delt/(delx * delx) * (-diag(ones(Ntot - 1, 1), 1)/2 + ...
               eye(Ntot)-diag(ones(Ntot - 1, 1), -1)/2);
        C(1, 2) = 2 * C(1, 2);
        A_1 = [eye(Ntot); C; zeros(2, Ntot)];

        %First newCPoints columns, which should be discarded (but will be
        %reused!)diag
        P1 = A_1(:, 1:newCPoints);
        A_1 = A_1(:, (newCPoints + 1):end);

        %Second column block (u_k) 
        A_2 = [-delt/2 * eye(Ntot); eye(Ntot); zeros(2, Ntot)];

        %Third column block (P_k)
        Sk = 2 * ones(1, newCPoints);
        if newCPoints > 1
            Sk(1) = 1;
            Sk(end) = 3/2;
        elseif newCPoints == 1
            Sk(1) = 1/2;
        end
        Sk = (Ma * delx * delt / 2) * Sk ;
        A_3 = [zeros(Ntot, newCPoints); ...
               (delt/2)  * eye(newCPoints); ...
               zeros(Ntot - newCPoints + 1, newCPoints); ...
               -Sk];

        %Now last column (z_k and v_k)
        %Remember: this column is the sum of the rows of the discarded matrix,
        %P1. That's why we use ones(__, 1)
        A_4 = [sum(P1, 2) zeros(2*Ntot + 2, 1)];
        A_4(end-1, 1) = 1;
        A_4(end-1, 2) = -delt/2;
        A_4(end, 2) = 1;

        A = [A_1 A_2 A_3 A_4];
        %%
        %Lets build the matrix B

        %First column-block (Eta_k)
        %Lets reuse the C defined for A_1 above.
        B_1 = [eye(Ntot); -C; zeros(2, Ntot)];

        %Second column-block (u_k)
        B_2 = [delt/2 * eye(Ntot); eye(Ntot); zeros(2, Ntot)];

        %Third column-block (P_k)
        oldCPoints = length(P_k);
       
        if oldCPoints > 0
            B_3 = [zeros(Ntot, oldCPoints); (-delt/2)  * eye(oldCPoints)];
            B_3 = [B_3; zeros(Ntot - oldCPoints + 1, oldCPoints)];
            aux = 2 * ones(1, oldCPoints);

            if oldCPoints > 1
                aux(1) = 1;
                aux(end) = 3/2;
            elseif oldCPoints == 1
                aux(end) = 1/2; 
            end
            aux = (Ma * delt * delx / 2) * aux;
            B_3 = [B_3; aux];
            
            %assert(size(B_3, 1) == 2*Ntot+2);
        else
            B_3 = zeros(2*Ntot + 2, 0);
        end
        
        %Fourth column-block (z_k and v_k)
        B_4 = [zeros(2*Ntot, 2); [1 delt/2; 0 1]];
        
        B = [B_1 B_2 B_3 B_4];

        %%
        %Now lets build the y vector
        y = [Eta_k; u_k; P_k; z_k; v_k];

        %%
        %Now lets build z, the "free vector"
        f = @(x, i) sqrt(1 - (x*x * i .* i));
        z = f(delx, 0:(newCPoints-1))'; %it has to be a row vector!
        z = P1 * z;
        z(end) = -delt/Fr;

        %%
        %Now lets solve the system and set the outputs.

        x = A\(B * y + z);
        z_k_prob = x(end - 1);
        v_k_prob = x(end);
        % Eta_k_prob = zeros(Ntot, 1);
        Eta_k_prob = z_k_prob - f(delx, 0:(newCPoints - 1))';
        Eta_k_prob = [Eta_k_prob; x(1:(Ntot - newCPoints))];
        
        u_k_prob = x((Ntot - newCPoints + 1):(2*Ntot - newCPoints));
        P_k_prob = x((2 * Ntot - newCPoints + 1):(2*Ntot));
        
        assert(size(Eta_k_prob, 1) == Ntot);
        assert(size(u_k_prob, 1) == Ntot);
        assert(size(P_k_prob, 1) == newCPoints);
        assert(size(x, 1) == 2*Ntot + 2);

        %%
        %Finally, lets calculate the angle error of the solution. The
        %definition depends on the expression newCPoints > 0
 
        if newCPoints > 0
            % tanSphere is the perfect tangent at a point near the last
            % contact point
            aux = delx*(newCPoints - 1) + delx/2;
            tanSphere = aux/sqrt(1-aux^2);


            %lets calculate the approximation of the tangent
            approximateTan = (Eta_k_prob(newCPoints + 1) - Eta_k_prob(newCPoints))/delx;

            %Return the absolute value of the difference
            errortan = abs(tanSphere - approximateTan);

        else
            
            %Dist is the distance vector of every probable point to the probable 
            %center of the sphere.
            dist = (Eta_k_prob - z_k_prob).^2 + (delx * (0:(Ntot-1))').^2;
            %If they collide, then smth is wrong.
            if any(dist <= 1)
                errortan = Inf;
            else
                errortan = 0;
            end

        end %end newCPoints > 0 condition if.

    end %End outer if
end