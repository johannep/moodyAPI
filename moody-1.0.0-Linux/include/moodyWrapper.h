/*======================================================================
 * MOODY: the spectral/hp element MOOring DYnamics solver
 *
 * Copyright (c) 2014, Johannes Palm, Claes Eskilsson
 * All rights reserved.
 *
 * This file is part of MOODY
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
 * WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * moodyWrapper.h: 
 ======================================================================*/

//
//  moodyWrapper.h
//  
//
//  Created by Johannes Palm on 19/05/16.
//
//

#ifndef ____moodyWrapper__
#define ____moodyWrapper__



#ifdef __cplusplus
extern "C"
{
#endif
    
    /** Initialisation call to moody. Required to setup the API.
        Parameter fName:            input file name (including path and extension)
        Parameter nVals:            number of values in parameter initialValues
        Parameter initialValues:    array of initial values of the boundary conditions (global frame)
        Parameter startTime:        time at start of simulation (s)
     */
    void moodyInit(const char* fName, int nVals,double initialValues[], double startTime );
    
    /** Solves the itnernal system of mooring dynamics between time t1 and t2. 
        Parameter X:                Boundary condition values at time t2.
        Parameter F:                Returned as the outward pointing mooring forces for each boundary condition dof.
        Parameter t1:               Time of last call, start time of time integration.
        Parameter t2:               End time of present time step simultation. 
            
        t1 and t2 are stored internally, together with corresponding states of the mooring dynamics. If t1 has increased since the last call, moody will move forward in time and store the state at t1 as the new starting state of the mooring dynamics. Hence, several iterations can be made with varying t2 but the same t1 without loosing the backup starting state. Compatible with predictor/corrector type time stepping schemes.
     */
    void moodySolve(const double X[], double F[], double t1, double t2);
    
    /** Closes the moody simulation and stores data for post processing */
    void moodyClose();

#ifdef __cplusplus
}
#endif

#endif /* defined(____moodyWrapper__) */
