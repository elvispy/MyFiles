""" Returns the matrices of the equation of movement to use in euler_sparse

Author: Elvis Agüero <elvisavfc65@gmail.com>

Created: 27th November, 2021
"""

from scipy.sparse import csc_matrix, coo_matrix, identity, vstack, hstack
import numpy as np
def returnMatrices(mcPoints, Ntot, dr, Re):
    """
    Doc Here
    """

    As = {i:None for i in range(mcPoints+1)}

    I_M = identity(Ntot, dtype = np.float64)
    zeroSparse = lambda A, B: csc_matrix((A, B), dtype = np.float64)
    Z_M = zeroSparse(Ntot, Ntot)

    A_prime = 2 * np.eye(Ntot)
    A_prime[0, 0] = 4
    A_prime[0, 1] = -4

    for i in range(1, Ntot):
        A_prime[i, i-1] = -(2*i-1)/(2*i)
        if i < Ntot-1:
            A_prime[i, i+1] = -(2*i+1)/(2*i)
        
    A_prime = (1 / dr**2) * A_prime

    A_2 = vstack([-I_M, Z_M, zeroSparse(2, Ntot)], format = 'csc')
    A_3 = vstack([ Z_M, I_M, zeroSparse(2, Ntot)], format = 'csc')

    for newCPoints in range(mcPoints+1):
        i = [0] * (2*Ntot - newCPoints + 2)# np.zeros((2*Ntot - newCPoints + 2, ))
        j = [0] * (2*Ntot - newCPoints + 2)# np.zeros((2*Ntot - newCPoints + 2, ))

        myA_prime = A_prime.copy()
        myA_prime[:newCPoints, :] = 0
        myA_prime = csc_matrix(myA_prime)

        myA_1 = vstack([Z_M, myA_prime, zeroSparse(2, Ntot)], format = 'csc')

        residual_1 = myA_1[:, :newCPoints] + \
            vstack([np.eye(newCPoints), np.zeros((2*Ntot-newCPoints+2, newCPoints))])

        myA_1 = myA_1[:, newCPoints:]

        i[:(Ntot - newCPoints)] = range(Ntot - newCPoints)
        j[:(Ntot - newCPoints)] = range(Ntot - newCPoints)

        myA_2 = A_2.copy()
        residual_2 = myA_2[:, :newCPoints]
        myA_2 = myA_2[:, newCPoints:]

        i[(Ntot-newCPoints):(2*Ntot - 2*newCPoints)] = range(Ntot, 2*Ntot - newCPoints)
        j[(Ntot-newCPoints):(2*Ntot - 2*newCPoints)] = range(Ntot - newCPoints, 2*Ntot - 2*newCPoints)

        i[(2*Ntot-2*newCPoints):(2*Ntot - newCPoints)] = range(Ntot - newCPoints, Ntot)
        j[(2*Ntot-2*newCPoints):(2*Ntot - newCPoints)] = [2*Ntot - newCPoints + 1] * newCPoints

        myA_3 = A_3[:, :newCPoints].copy()
        myA_3[-1, :] = -(dr**2) * Re * csc_matrix(int_vector(newCPoints))

        myA_4 = hstack([np.sum(residual_1.toarray(), axis = 1, keepdims=True), \
            np.sum(residual_2.toarray(), axis = 1, keepdims=True), csc_matrix((2*Ntot+2, 0))], format = 'csc')
        myA_4[-2, -1] = -1
        myA_4 = csc_matrix(myA_4, dtype = np.float64)
        myA = hstack([myA_1, myA_2, myA_3, myA_4], format = 'csr')
        myA = myA[newCPoints:, :]

        i[-2] = 2*Ntot - newCPoints
        j[-2] = 2*Ntot - newCPoints
        i[-1] = 2*Ntot - newCPoints + 1
        j[-1] = 2*Ntot - newCPoints + 1
        
        mydict = {}
        mydict['A'] = myA
        mydict['residual_1'] =  residual_1
        mydict['ones'] = coo_matrix((np.ones((len(j), )), (i, j)), dtype = np.float64)

        As[newCPoints] = mydict

    return As
    
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




if __name__ == '__main__':
    AA = returnMatrices(3, 4, 1, 1)