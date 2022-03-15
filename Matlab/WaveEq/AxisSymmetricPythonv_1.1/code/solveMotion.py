"""Solves the equation of motion of the sphere-membrane coupled system
A module with the main function 'solveMotion' and an auxiliary function 'initialConditions'
which solves the static version of the problem, in which the membrane does not move. 

Author: Elvis Agüero <elvisavfc65@gmail.com>

Created: 4th November, 2021
"""


# Standard Library imports
# from _typeshed import NoneType
import pickle
from pathlib import Path
import csv
from datetime import datetime
import logging
logging.basicConfig(filename = 'debug.log', filemode = 'a', level = logging.INFO, \
    format='%(asctime)s %(message)s')

# Third Party Imports
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt

# General plot parameters
#mpl.rcParams['font.family'] = 'Avenir'
mpl.rcParams['font.size'] = 18
mpl.rcParams['axes.linewidth'] = 2
mpl.rcParams['axes.spines.top'] = False
mpl.rcParams['axes.spines.right'] = False
mpl.rcParams['xtick.major.size'] = 10
mpl.rcParams['xtick.major.width'] = 2
mpl.rcParams['ytick.major.size'] = 10
mpl.rcParams['ytick.major.width'] = 2
plt.figure(figsize = (8, 6), dpi = 80)


# Modules
def solveMotion(rS: np.float64 = 1.0, Tm: np.float64 = 72, R_f: np.float64 = -1, \
    mu: np.float64 = 1.68e-2, mS: np.float64 = 0, g = 9.80665e-3, z_k = -1, v_k = -0.1, Eta_k = [],\
    u_k = [], P_k = [], simulTime: np.float64 = 50.0, recordTime = 0.001, 
    FileName: str = "historial.csv", plotter: bool = True, method: str = 'Euler', \
    saveAfterContactTime: bool = False, exportData: bool = False) -> None:

    '''
    Solves the full kinematic match given initial conditions. 
    
    Parameters:
    ----------
    rS: np.float64
        Radius of the sphere (in mm).
    Tm: np.float64
        Internal tension of the membrane (in mg / ms^2)
    R_f: np.float64
        Number of radii in half a length of the membrane (dimensionless)
        This variable has the default value 52.4/rS, assigned if it has
        the flag value -1
    mu: np.float64
        Mass density of the membrane per unit area (mg/mm^2)
    mS: np.float64
        Mass of the sphere (in mg)
    g: np.float64
        Gravity of the earth (in mm/ms^2)
    z_k: np.float64
        Initial position of the center of the sphere (in mm)
    v_k: np.float64
        Initial velocity of the center of the sphere (in mm)
    Eta_k: np.ndarray
        Initial position of half the membrane (in mm)
    u_k: np.ndarray
        Initial velocity of half the membrane (in mm/ms)
    simulTime: np.float64
        Total time to be simulated (in ms)
    recordTime: np.float64
        Time Step to save in the matrix (in ms)
    FileName: str
        Name of the file to store summarized results
    plotter: bool
        Boolean indicating whether to plot real-time results
    method: str
        Indicates which method to be used. Default 'Euler'.
        As of 25/12, its the only method implemented. BDF2 is on implementation stage
    saveAffterContactTime: bool
        Tells the code to save data after contact ended. Useful when trying to understand 
        variables related to the impact only.
    exportData: bool
        Boolean flag which determines whether data will be exported in pkl format.


    Outputs:
    ----------
    No direct outputs are returned However, two files are created.
    Simulation{TimeStamp}.pkl stores a number of variables for later post-processing, including:
    
    pickle.dump([recordedEta, recordedz_k, recordedPk, \
            ctime, maxDef, Tm, rS, rt, v_k, N], f)
            

    '''

    # Handling some default Values
    if R_f == -1: R_f = 52.4/rS
    if mS  ==  0: mS  = 7.8 * 4 * np.pi * (rS**3) / 3
    if method == 'Euler':
        from euler import euler as getNextStep
    else:
        pass # import trapecio as getNextStep

    # Now we define some physical constants
    Fr = (mu*rS*g)/Tm # Froude number
    Re = mu*(rS**2)/mS # "Reynolds" number

    #Physical units
    Lunit = rS # Spatial unit of mesurement (mm)
    Vunit = np.sqrt(Tm/mu) # Velocity in (mm/ms)
    Tunit = Lunit/Vunit # Temporal unit of measurement (ms)
    Punit = mu * Lunit / Tunit**2 # Unit of pressure (mg/(ms^2 * mm))

    # A few Nmerical constants
    N = np.int16(25) # np.int32(np.ceil(500/R_f)) # Number of dr intervals in one radial adimensional unit length (Adimensional)
    Ntot = np.int32(np.ceil(R_f * N)) # Total number of non-trivial points in the radial adimensional coordinate (Adimensional)
    dr = 1/N # Radial step (Adimensional)

    if recordTime == 0:
        dt = 1/(5*N*Tunit)
    else:
        dt = recordTime/Tunit # Initial time step (Adimensional)
    finalTime = simulTime/Tunit # Maximum time to be simulated (Adimensional)
    t = 0/Tunit # Initial time (Adimensional)
    rt = dt # Interval of time to be recorded in the output matrix


    ## Initial conditions
    u_k = np.zeros((Ntot, ))
    Eta_k = initialConditions(dr, Ntot, Fr)

    if z_k == -1:
        z_k = Eta_k[0] + 1
    else:
        assert z_k >= Eta_k[0] + 1
        z_k = z_k/Lunit
    
    v_k = v_k/Vunit

    z_k_prob = np.zeros((6, )) # Initial position of the center of the ball
    v_k_prob = np.zeros((6, )) # Initial velocity of the ball (previous and following times)
    Eta_k_prob = np.zeros((Ntot, 6)) # Position of the membrane at different times
    u_k_prob = np.zeros((Ntot, 6)) # Velocities of the membrane at different times


    ## Flow control variables
    cPoints = len(P_k) # Variable to record number of contact points
    ctime = 0 # Variable to record contact Time
    maxDef = 0 # Variable to sve maximum deflection
    ch = True
    contactFlag = False
    maxDeflectionRecorded = False 
    iii = 0
    jjj = 0
    resetter = 1
    mCPoints = N + 1 # Maximum number of allowed contact points

    FolderPath = Path(__file__).parent.parent / "output"
    FileName = FolderPath / FileName
    if Path.exists(FileName) == False:
        with open(FileName, 'w') as f:
            writer = csv.writer(f)
            writer.writerow(["ID", "vi", "surfaceTension", "radius", \
            "cTime", "maxDeflection"])

    
    currentIndex = 1 # initial saving index, for saving matrix, initializes in 1 since 0 is left for initial conditions
    numberOfExtraIndexes = 0
    maximummIndex = np.int64(np.ceil((finalTime - t)/rt) + 4) # Maximum index 

    recordedz_k = np.zeros((maximummIndex, 1))
    recordedEta = np.zeros((maximummIndex, Ntot))
    recordedPk = np.zeros((maximummIndex, mCPoints))
    recordedu_k = np.zeros((maximummIndex, Ntot))
    recordedv_k = np.zeros((maximummIndex, 1))
    recordedTimes = np.zeros((maximummIndex, 1))

    recordedz_k[0, :] = z_k * Lunit
    recordedEta[0, :] = Eta_k * Lunit
    #recordedu_k[0, :] = u_k * Vunit
    recordedv_k[0, :] = v_k * Vunit
    recordedTimes[currentIndex] = t * Tunit


    vars = [datetime.now().strftime('%M%S'), 0]
    coefOfRestitution = np.nan

    # For plotting
    width = 3*N # Number of radii to be plotted
    xplot = np.linspace(0, width/N, width)
    aux = np.linspace(0, 2*np.pi, 50)
    circleX = np.cos(aux) * Lunit
    circleY = np.sin(aux) * Lunit
    EtaX = np.concatenate((-xplot[:0:-1], xplot)) * Lunit
    EtaU = np.zeros((2*width-1, ))
    step = np.int16(N/15) + 1


    # Main Loop
    while (t <= finalTime):
        errortan = np.Inf * np.ones((6,))
        recalculate = False

        # FIrst, we try to solve with the same number of contact points
        [Eta_k_prob[:,3], u_k_prob[:, 3], z_k_prob[3], \
            v_k_prob[3], Pk_3, errortan[3]] = getNextStep(cPoints, mCPoints, \
            Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Re, Ntot)

        if errortan[3] < 1e-8:
            Eta_k = Eta_k_prob[:, 3].copy()
            u_k = u_k_prob[:, 3].copy()
            z_k = z_k_prob[3].copy()
            v_k = v_k_prob[3].copy()
            P_k = Pk_3.copy()

        else: # If there is some error, we try with a diffferent contact points
            # Lets try with one more point
            [Eta_k_prob[:,4], u_k_prob[:, 4], z_k_prob[4], \
                v_k_prob[4], Pk_4, errortan[4]] = getNextStep(cPoints + 1, mCPoints, \
                Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Re, Ntot)

            # Lets try with one point less
            [Eta_k_prob[:,2], u_k_prob[:, 2], z_k_prob[2], \
                v_k_prob[2], Pk_2, errortan[2]] = getNextStep(cPoints - 1, mCPoints, \
                Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Re, Ntot)

        
            if (errortan[3] > errortan[4] or errortan[3] > errortan[2]):
                if errortan[4] <= errortan[2]:
                    # Now lets check with one more point to be sure
                    [_, _, _, _, _, errortan[5]] = getNextStep(cPoints + 2, mCPoints, \
                        Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Re, Ntot)
                    
                    if errortan[4] < errortan[5]:
                        # Accept new data
                        Eta_k = Eta_k_prob[:, 4].copy()
                        u_k = u_k_prob[:, 4].copy()
                        z_k = z_k_prob[4].copy()
                        v_k = v_k_prob[4].copy()
                        P_k = Pk_4.copy()
                        cPoints = cPoints + 1
                    else:
                        # time step too big
                        recalculate = True
                else:
                    # now lets check if errortan is good enough with one point
                    # less
                    [_, _, _, _, _, errortan[1]] = getNextStep(cPoints-2, mCPoints, \
                Eta_k, u_k, z_k, v_k, P_k, dt, dr, Fr, Re, Ntot)

                    if errortan[2] < errortan[1]:
                        Eta_k = Eta_k_prob[:, 2].copy()
                        u_k = u_k_prob[:, 2].copy()
                        z_k = z_k_prob[2].copy()
                        v_k = v_k_prob[2].copy()
                        P_k = Pk_2.copy()
                        cPoints = cPoints - 1

                    else:
                        recalculate = True
            else: # The same number of contact points is best 
                if errortan[3] == np.Inf:
                    recalculate = True
                else:
                    Eta_k = Eta_k_prob[:, 3].copy()
                    u_k = u_k_prob[:, 3].copy()
                    z_k = z_k_prob[3].copy()
                    v_k = v_k_prob[3].copy()
                    P_k = Pk_3.copy()
        
        if recalculate == True:
            dt = dt/2 # Reduce time step
            iii+=1 #Refine spatial grid
            jjj*=2 # Adjust current spatial grid index
        else:
            # Add time step
            t = t + dt
            jjj += 1
            if jjj%2 == 0 and resetter > 0:
                jjj /=2
                iii -=1
                dt *=2
                resetter -=1


            #---------------
            #---------------
            # Update indexes if necessary and store results in a matrix
            if currentIndex > maximummIndex:
                raise Exception("We are not prepared for this!")
            recordedz_k[currentIndex, :] = z_k * Lunit
            recordedEta[currentIndex, :] = Eta_k * Lunit
            recordedPk[currentIndex, 0:len(P_k)] = P_k * Punit
            recordedv_k[currentIndex, :] = v_k * Vunit
            recordedTimes[currentIndex] = t * Tunit
            currentIndex += 1
            if jjj == 2**iii:
                jjj = 0
                resetter = 1
            else:
                numberOfExtraIndexes +=1


            # Plotting
            # ----------
            if plotter == True:
                plt.cla()
                plt.plot(circleX , (z_k * Lunit + circleY) , linewidth = 2, 
                        color = 'b')
                plt.axis([-width * Lunit/N, width*Lunit/N, \
                    (z_k - 2) * Lunit, (z_k + 2) * Lunit])
                EtaY = np.concatenate((Eta_k[(width-1):0:-1], Eta_k[:width])) * Lunit
                plt.plot(EtaX, EtaY, linewidth = 2, color = 'black')
                EtaV = np.concatenate((u_k[(width-1):0:-1], u_k[:width])) * Vunit
                plt.quiver(EtaX[::step], EtaY[::step], EtaU[::step], EtaV[::step], \
                     color  = 'orange', scale = .8, scale_units = 'x')
                plt.title(f't = {t*Tunit:0.4f} (ms),  CP = {cPoints} , vz = {v_k * Vunit:0.5f}')
                plt.pause(0.005)

            else:
                pass
            # ----------

            # Analise contact time and maximum deflection
            if (contactFlag == False and cPoints > 0):
                contactFlag = True
                maxDef = recordedz_k[currentIndex - 2, 0]
                vars[1] = np.round(recordedv_k[currentIndex - 2, 0], 5)
                zeroPotential = recordedEta[currentIndex - 2, 0] + rS
                Em_in = 1/2 * mS * ((recordedv_k[currentIndex - 2])**2)
            elif (contactFlag == True and cPoints > 0):
                ctime += dt
            elif (contactFlag == True and cPoints == 0):
                if maxDeflectionRecorded == False:
                    Em_out = 1/2 * mS * ((recordedv_k[currentIndex - 1])**2) \
                        + mS*g*(recordedz_k[currentIndex - 1, 0] - zeroPotential)
                maxDeflectionRecorded = True
                if saveAfterContactTime == False:
                    break # end simulation if contact ended.

            if (contactFlag == True and v_k > 0):
                # If velocity has changed sign, record maximum only once
                if (ch == True): 
                    maxDef = maxDef - recordedz_k[currentIndex-1]
                    ch = False
    # Post Processing
    if plotter == True:
        # Close Plots
        pass

    ctime = np.round(ctime * Tunit, 10)
    maxDef = np.round(maxDef, 10)
    v_k = vars[1]
    rt = rt * Tunit
    coefOfRestitution = Em_out/Em_in

    if exportData == True:
        recordedz_k = recordedz_k[:currentIndex]
        recordedEta = recordedEta[:currentIndex, :]
        recordedPk = recordedPk[:currentIndex, :]
        recordedv_k = recordedv_k[:currentIndex, :]
        recordedTimes = recordedTimes[:currentIndex, :]

        
        with open(FolderPath / f"simulation{vars[0]}.pkl", 'wb') as f:
            pickle.dump([recordedEta, recordedz_k, recordedPk,  recordedv_k, recordedTimes, \
                ctime, maxDef, Tm, rS, rt, v_k, N, coefOfRestitution], f)

        with open(FileName, 'a') as f:
            writer = csv.writer(f)
            writer.writerow(["ID", vars[1] , Tm, rS, ctime, maxDef])
    
    logging.info('Radius: %0.4f mm', rS)
    logging.info('Tm: %0.3g ', Tm)
    logging.info('Contact time: %0.5f (ms)', ctime)
    logging.info('Maximum deflection: %0.5f (mm)', maxDef)
    logging.info('Coefficient of restitution squared: %0.3f', coefOfRestitution)
    logging.info('dt: %0.5g (ms)', dt*Tunit)
    logging.info('dr: %0.5g (mm)', dr * Lunit)
    logging.info('-----------------------------')


def initialConditions(dr: float, Ntot: int, Fr: float) -> np.ndarray:
    '''Returns the position of the membrne which is the solution
    of the static problem for the membrane. 
    Since A_prime determines the position of the membrane when 
    there are no contact points, this position vector eta should satisfy
    A*eta = eta + R
    
    Parameters:
    ----------
    dr: float
        Spatial grid spacing of the discretized version of the problem.
    Ntot: int
        Number of non-trivial spatial points in the system
    Fr: float
        Frobenius Constant of the system, equal to the density of the membrane, 
        times the radius, times gravity, divided by tension (mu * rS * g) / Tm
    
    Outputs:
    ----------
    eta: np.array, dtype = 'float64'
        Vector representing the position of the membrane and which is 
        in numerical equilibrium in this discretized version (i.e. when passed
        as argument for euler or trapecio, it will return the same vector as output)
    '''

    # Building A_prime

    # First entries in the tridiagonal matrix
    A_prime =  np.eye(Ntot) / (dr**2)
    A_prime[0, 0] = 2/(dr**2)
    A_prime[0, 1] = -2/(dr**2)

    # All the other entries
    for i in range(1, Ntot-1):
        A_prime[i, i-1] = -(1/(2*dr**2)) * (2*i-1)/(2*i)
        A_prime[i, i+1] = -(1/(2*dr**2)) * (2*i+1)/(2*i)
    
    # Last entry
    A_prime[-1, -2] = -1/(2*dr**2) * (2*Ntot - 3)/(2*Ntot-2)
    # Building RHS of the system
    R = -Fr * np.ones((Ntot, 1))
    # Solving the system
    eta = np.linalg.solve(A_prime, R)/2
    eta.shape = (Ntot, )
    return eta 


if __name__ == '__main__':

    rS = np.float64(0.795) # Radius of the sphere (in mm)
    R_f = 10 # 52.4/rS # Number of raddi in half a length of the membrane (dimensionless)
    Tm = np.float64(20) # np.float64(73) # Tesion of the membrane (mg/ms^2)
    g = 9.80665e-3 # Gravity of earth (mm/ms^2)
    mu = 1.68e-2 # Density of membrane per unit of area (mg/mm^2) (Sara Wrap membrane)
    mS = 7.8 * 4 * np.pi * (rS**3) / 3 # Mass of the ball (mg) (7.8 is the ball's 
    # density in mg/mm^3)

    solveMotion(rS = rS, Tm = Tm, R_f = R_f, v_k = -0.29238806, \
        plotter = True, recordTime=0.01)