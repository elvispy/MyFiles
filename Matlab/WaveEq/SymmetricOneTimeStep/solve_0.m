function [Eta_k_prob, u_k_prob, z_k_prob, v_k_prob, errortan] = ...
    solve_0(Eta_k, u_k, z_k, v_k, delt, delx, Ntot, c1, R)
    %This function solves the  system Ax = By + z 
    %when no pressure is being applied.
    %%
    %Lets build the A matrix.
    A_1 = [eye(Ntot) -delt/2 * eye(Ntot)];
    C = [delt/(delx*delx) * (-diag(ones(Ntot-1, 1), 1)/2 + eye(Ntot) + ...
        -diag(ones(Ntot-1, 1), -1)/2), eye(Ntot)];
    C(1, 2) = 2 * C(1, 2);
    A_1 = [A_1; C];
    % A_2 = [1 -delt/2; 0 1];
    % A = [A_1 zeros(2* Ntot, 2); zeros(2, 2* Ntot) A_2];
    
    %%
    %Lets build the Matrix b
    B_1 = [eye(Ntot) delt/2 * eye(Ntot)];
    B_1 = [B_1; -C];

    B_2 = [1 delt/2; 0 1];
    
        
    %%
    %Now lets define  and y
    y = [Eta_k; u_k];
    
    %And finally solve.
    x = A_1\(B_1*y);
    res =  B_2 * (B_2 * [z_k;v_k] + [0;c1 * delt]);

    
    %% 
    %Now lets define the return variables
    Eta_k_prob = x(1:Ntot);
    u_k_prob   = x(Ntot+1:2*Ntot);
    z_k_prob   = res(1);
    v_k_prob   = res(2);
    
    %Dist is the distance vector of every probable point to the probable 
    %center of the sphere.
    dist = (Eta_k_prob - z_k_prob).^2 + (delx * (0:(Ntot-1))').^2;
    dist = sqrt(dist);
    %If they collide, then smth is wrong.
    if any(dist < R)
        errortan = Inf;
    else
        errortan = 0;
    end
    
end