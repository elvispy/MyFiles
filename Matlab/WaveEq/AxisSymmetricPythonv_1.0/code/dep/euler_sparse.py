"""Returns a one time step solution for the equation of motion of a sphere-membrane
coupled system.
A module with "euler", the main function that computes the solution
and an auxiliary function "int_vector" which is used by euler

Author: Elvis Agüero <elvisavfc65@gmail.com>

Created: 4th November, 2021
"""
# Imports 
import numpy as np
import scipy.sparse.linalg as LinAlg


# Modules
def euler_sparse(newCPoints, mCPoints, Eta_k, u_k, \
    z_k, v_k, _, dt, dr, Fr, Ntot, AA):
    ''' This script will solve the equation of motion of the
    sphere-membrane coupled system. 

    Parameters
    ----------
    newCPoints: int
        Integer denoting the new number of contact points 
        to be applied to the coupled system
    mCPoints: int
        Maximum number of physically allowed contact points
    Eta_k: np.array, dtype = float64
        Vector representing the position of the membrane before 
        solving the system
    u_k: np.array, dtype = float64
        Vector representing the vertical components of the velocities
        of the membrane
    z_k: float
        Position of the center of the sphere with respect to the vertical axis
    v_k: float
        Velocity of the center of the sphere with respect to the vertical axis
    P_k: np.array, dtype = float64
        Vector of pressures in contact points. (Not used in Euler!)
        Only non-trivial entries are stored in this variable.
    dt, dr: float
        Temporal and spatial grid spacing, respectively.
    Ntot: int
        Number of non-trivial spatial points in the system
    Fr: float
        Frobenius Constant of the system, equal to the density of the membrane, 
        times the radius, times gravity, divided by tension (mu * rS * g) / Tm
    Re: float
        Reynolds Number, equal to the density of the membrane, times rS squared,
        divided by the mass of the sphere

    Outputs:
    ----------
    Eta_k_prob: np.array, dtype = float64
        Vector representing the position of the membrane after 
        solving the system
    u_k_prob: np.array, dtype = float64
        Vector representing the vertical components of the velocities
        of the membrane after solving the system
    z_k_prob: float
        Position of the center of the sphere with respect to the vertical axis
    v_k_prob: float
        Velocity of the center of the sphere with respect to the vertical axis
    P_k_prob: np.array, dtype = float64
        Vector of pressures in contact points after solving the system.
        Only non-trivial entries are stored in this variable.

    '''
    if newCPoints < 0 or newCPoints > mCPoints:
        errortan = np.Inf
        Eta_k_prob = np.NaN * np.zeros((Ntot, ))
        u_k_prob = np.NaN * np.zeros((Ntot, ))
        z_k_prob = np.NaN
        v_k_prob = np.NaN
        P_k_prob = np.NaN
    else:
    
        # Building R and R prime
        R = np.vstack((np.zeros((Ntot - newCPoints, 1)), \
             (-Fr * dt) * np.ones((Ntot, 1)), np.array([[0.0], [-Fr*dt]])))
        for ii in range(Ntot-newCPoints , Ntot):
            R[ii] = R[ii] + 2 * dt

        f = lambda x: np.sqrt(1-dr**2 * (x*x))


        residual_1 = AA[newCPoints]['residual_1']
        if newCPoints > 0:
            residual_1[Ntot + newCPoints, -1] *= dt
        
        myvec = np.linspace(0, newCPoints-1, newCPoints).reshape(newCPoints, 1)
        R_prime = residual_1 @ f(myvec)
        R_prime = R_prime[newCPoints:]

        # Solving the system
        x = np.vstack((Eta_k.reshape((Ntot, 1)), u_k.reshape((Ntot, 1)),  \
            np.array([[z_k], [v_k]]))); x = x[newCPoints:]
        results = LinAlg.spsolve(dt*AA[newCPoints]['A'] + AA[newCPoints]['ones'], x+R+R_prime)

        z_k_prob = results[-2, 0]
        v_k_prob = results[-1, 0]
        Eta_k_prob = z_k_prob - f(myvec)
        Eta_k_prob = np.concatenate((Eta_k_prob, results[0:(Ntot - newCPoints)])); Eta_k_prob.shape = (Ntot, )

        u_k_prob = v_k_prob * np.ones((newCPoints, 1))
        u_k_prob = np.concatenate((u_k_prob, results[(Ntot - newCPoints):(2*Ntot - 2 * newCPoints)]))
        u_k_prob.shape = (Ntot, )
        P_k_prob = results[(2*Ntot - 2*newCPoints):(2*Ntot - newCPoints)]; P_k_prob.shape = (newCPoints, )

        # Calculating errortan
        errortan = 0

        if newCPoints != 0:
            g = lambda x: x/np.sqrt(1-x*x); ppt = (newCPoints-1)*dr + dr/2
            approximateSlope = (Eta_k_prob[newCPoints] - Eta_k_prob[newCPoints-1])/dr
            exactSlope = g(ppt)
            errortan = np.abs(np.arctan(approximateSlope) - np.arctan(exactSlope))

        for ii in range(newCPoints, mCPoints):
            if Eta_k_prob[ii] > z_k_prob - f(ii):
                errortan = np.Inf
                break
        
    return [Eta_k_prob, u_k_prob, z_k_prob, v_k_prob, P_k_prob, errortan]


def int_vector(n: int):
    ''' Returns the integration vector without dhe dr^2 factor 
    that is goes into the Pk block

    Parameters
    -----------
    n: Integer. 
        Number of elements in the integrations vector
    
    Returns
    ----------
    S: np.array
        1 by n array of floating points to perform numerical integration
    '''

    if n == 0:
        # In this case, an array of size (1, 0)
        S = np.zeros((1, 0), dtype='float64')
    elif n == 1:
        #Lets return an array of size (1, 1)
        S = np.array([[np.pi/12]])
    else:
        S = np.pi * np.ones((n, ))
        S[0] = 1/3 * S[0]
        for i in range(1, n-1):
            S[i] = 2 * i * S[i]
        S[-1] = (3/2 * (n-1)  - 1/4) * S[-1]

    return S.reshape((1, n))
