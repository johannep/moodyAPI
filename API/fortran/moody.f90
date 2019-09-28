!=======================================================================
MODULE moody


   ! This MODULE stores variables and routines used in these time domain
   !   hydrodynamic loading and mooring system dynamics routines for the
   !   floating platform.

!=======================================================================
! INTERFACE FUNCTION FOR INITIALISATION
INTERFACE
	SUBROUTINE moodyInit (fName, nVals, initialValues, startTime ) bind ( c, name='moodyInit' )
		use iso_c_binding
		IMPLICIT NONE
			
		character ( c_char ), INTENT(IN) :: fName(*)
	  	integer (c_int ), INTENT(IN) , VALUE :: nVals
	  	real (c_double ), INTENT(IN) :: initialValues(*)  	
	  	real (c_double ), INTENT(IN) , VALUE:: startTime
	  	
 	END SUBROUTINE moodyInit

!=======================================================================		      
! INTERFACE FUNCTION FOR SOLVING FROM t1 to t2, where X is the platform state at t=t2

  	SUBROUTINE moodySolve (X, F, t1 , t2 )  bind (  c, name='moodySolve'  )
	 	use iso_c_binding   
	 	IMPLICIT NONE
	 			
	  	real (c_double ), INTENT(IN) :: X (6)
	  	real (c_double ), INTENT(OUT) :: F (6)
	  	real (c_double ), INTENT(IN), VALUE :: t1 	
	  	real (c_double ), INTENT(IN), VALUE :: t2
	  	
	 END SUBROUTINE moodySolve	 

!=======================================================================
! INTERFACE FUNCTION FOR CLOSING MOODY AND RUNNING DESTRUCTORS PROPERLY

	 SUBROUTINE moodyClose( ) bind ( c , name='moodyClose')
		use iso_c_binding
		IMPLICIT NONE
		
	  END SUBROUTINE moodyClose	
END INTERFACE

CONTAINS
!=======================================================================
! THESE FORTRAN SUBROUTINES ARE ADDED TO GET ACCES TO THE MOODY API VIA FAST

	SUBROUTINE moodyInitialise (fName, nVals, initialValues, startTime )
	
	USE                             Precision
		
    IMPLICIT                        NONE
		
		CHARACTER(1024), INTENT(IN) 	:: fName
	  	INTEGER(4), 	 INTENT(IN) , VALUE :: nVals
	  	REAL(ReKi), 	 INTENT(IN) :: initialValues(*)  	
	  	REAL(ReKi), 	 INTENT(IN) , VALUE:: startTime

			
		CALL moodyInit(TRIM(fName),nVals,initialValues,startTime)
						  	
	END SUBROUTINE moodyInitialise

!=======================================================================
	SUBROUTINE moodyAPI ( X       ,  F , lastTime    , curTime )


		! This is a wrapper for moody. 
		! The primary output of this routine is array F(:), which must
		! contain the 3 components of the total force from all mooring lines
		! (in N) acting at the platform reference and the 3 components of the
		! total moment from all mooring lines (in N-m) acting at the platform
		! reference; positive forces are in the direction of positive
		! platform displacement.  This primary output effects the overall
		! dynamic response of the system. 


		USE                             Precision

		IMPLICIT                        NONE


		! Passed Variables:

		REAL(ReKi), INTENT(OUT)      :: F        (6)                                    ! The 3 components of the total force from all mooring lines (in N) acting at the platform reference and the 3 components of the total moment from all mooring lines (in N-m) acting at the platform reference; positive forces are in the direction of positive platform displacement.
		REAL(ReKi), INTENT(IN )      :: X        (6)                                    ! The 3 components of the translational displacement (in m) of the platform reference and the 3 components of the rotational displacement (in rad) of the platform relative to the inertial frame.
		REAL(ReKi), INTENT(IN )      :: curTime                                           ! Current simulation time, sec.
		REAL(ReKi), INTENT(IN )      :: lastTime                                           ! Last known simulation time, sec.


			
		! Call moody interface function
		CALL moodySolve ( X , F , lastTime , curTime ) 

        RETURN
        
    END SUBROUTINE moodyAPI

!=======================================================================
! FORTRAN STYLE OF CALLING THE DESTRUCTOR EXPLICITLY. 
	SUBROUTINE moody_Terminate( )
      
		CALL moodyClose()
   
	END SUBROUTINE moody_Terminate
!=======================================================================

END MODULE moody


