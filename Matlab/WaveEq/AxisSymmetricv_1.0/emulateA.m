function [A, B] = emulateA(delt, delr, Ntot, newCPoints, Mr, P_k)

    %First column block (Eta_k)
    %Lets build A'
    A_prime = diag( delt/(delr^2) * ones(Ntot, 1)); %diagonal terms are equal
    A_prime(1, 1) =  (2*delt)/(delr^2);
    A_prime(1, 2) = -(2*delt)/(delr^2);
    for i = 2:(Ntot-1)
         A_prime(i, i-1)= -(delt)/(2*delr^2) * (2*i-3)/(2*i-2);
         A_prime(i, i+1)= -(delt)/(2*delr^2) * (2*i-1)/(2*i-2);
    end
    A_prime(Ntot, Ntot-1) = -(delt)/(2*delr^2) * (2*Ntot-1)/(2*Ntot-2); 

    A_1 = [eye(Ntot); A_prime; zeros(2, Ntot)];

    P1 = A_1(:, 1:newCPoints);
    A_1 = A_1(:, (newCPoints+1):end); %First columns discarded

    %Second colum block (u_k)
    A_2 = [-delt/2 * eye(Ntot); eye(Ntot); zeros(2, Ntot)];

    %Third column block (P_k)
    %Building the integration vector
    S = int_vector(newCPoints);
    S = - (delt/2 * Mr * delr^2) * S;

    A_3 = [zeros(Ntot, newCPoints); ...
          (delt/2) * eye(newCPoints); ...
          zeros(Ntot-newCPoints+1, newCPoints);...
          S];

    %Now last columns (z_k and v_k)

    A_4 = [sum(P1, 2) zeros(2*Ntot + 2, 1)];
    A_4(end-1, 1) = 1;
    A_4(end-1, 2) = -delt/2;
    A_4(end, 2) = 1;

    A = [A_1, A_2, A_3, A_4];
    
    %First column-block (Eta_k)
    B_1 = [eye(Ntot); -A_prime; zeros(2, Ntot)];

    %Second column block (u_k)
    B_2 = [(delt/2) * eye(Ntot); eye(Ntot); zeros(2, Ntot)];

    %third block (P_k)
    oldCPoints = length(P_k);

    B_3 = [zeros(Ntot, Ntot); delt/2 * eye(Ntot); zeros(1, Ntot)];

    B_3 = B_3(:, 1:oldCPoints);
    %Integration vector
    S =  (delt/2) * Mr * delr^2 * int_vector(oldCPoints);

    B_3 = [B_3; S];

    %Fourth column-block (z_k and v_k)
    B_4 = [zeros(2*Ntot, 2); [1 delt/2; 0 1]]; 

    B = [B_1 B_2 B_3 B_4];
end

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



