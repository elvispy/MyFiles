function [Eta_k_prob, u_k_prob, z_k_prob, v_k_prob, P_k_prob, errortan] = ...
    getNextStep(newCPoints, mCPoints, Eta_k, u_k, z_k, v_k, dt, ...
    dr, Fr, Mr, Ntot)
    
    %% Documentation
    % This function solves the system Ax = By + z to calculate the position
    % of the sphere and the elastic band, with pressure included
    % -)newCpoints = Number of pressure contact points at time k+1
    % -)Eta_k = Vector of vertical displacement of the rope
    % -)u_k = vector of vertical velocities of the rope
    % -)z_k = vertical position of the center of the ball
    % -)v_k = vertical velocity of the center of the ball
    % -)P_k = vector of pressures in the last time step. Only 
    % non-trivial points are inside
    % -)dt, dr = Temporal and spatial grid minimum difference,
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
        Eta_k_prob = zeros(size(Eta_k));
        u_k_prob = zeros(size(u_k));
        z_k_prob = 0;
        v_k_prob = 0;
        P_k_prob = 0;
       
    else
        if newCPoints == 0
            [Eta_k_prob, u_k_prob, z_k_prob, v_k_prob, errortan] = ...
            freefall(Eta_k, u_k, z_k, v_k, dt, dr, Fr, Ntot); P_k_prob = [];
        else
            [Eta_k_prob, u_k_prob, z_k_prob, v_k_prob, ...
                P_k_prob, errortan] = solveNcorner(newCPoints, Eta_k, u_k, ...
                z_k, v_k, dt, dr, Fr, Mr, Ntot);
        end
        

    end %end outer if
end %end function definition
