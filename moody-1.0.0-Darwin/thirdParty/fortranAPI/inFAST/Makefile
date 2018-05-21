SFUNC_NAME = FAST_SFunc.mexa64
PROG_NAME = FAST
PROG_TURB = TurbSim
PROG_CRUNCH = Crunch

export FFLAGS = -fdefault-real-8 -ffree-line-length-none -fPIC -O2 -mtune=native
#export FFLAGS = -fPIC -O2
#FC = gfortran
FC = /chalmers/sw/sup64/gcc-4.9.0/bin/gfortran
#FC = ifort

NWTC_LIB = nwtc
AERO_LIB = aero
WIND_LIB = inflow
FAST_LIB = fast
SIM_LIB = fast/Simulink
TURBSIM_LIB = turbsim
CRUNCH_LIB = crunch
TURBINE_PATH = turbines/
TURBINE_FOLDER = 5mwlinear
#TURBINE_FOLDER = 5mwonshore

# ADDITION BY JP:
moorDir = /chalmers/users/johannep

MATLAB_DIR = /chalmers/sw/sup64/matlab-2012b/
LIB = -L"$(MATLAB_DIR)bin/glnxa64"
LFLAGS = -shared  -Wl,--version-script,$(MATLAB_DIR)extern/lib/glnxa64/fexport.map -g -DMATLAB_MEX_FILE $(LIB) -lmex -lmat -lmx -lpthread 
export BASEDIR = $(PWD)
export OUTDIR = $(PWD)/build
TESTDIR = $(PWD)/tests

all: $(PROG_NAME) $(SFUNC_NAME) DISCON.so $(PROG_TURB)

ALL_OBJ = $(OUTDIR)/*.o
# ADDITION BY JP: -L$(moorDir)/lib -lmoodyWrap
$(PROG_NAME): nwtc_lib wind aero fast fix_build_dir
	$(FC) $(ALL_OBJ) $(OUTDIR)/native/*.o -ldl -L$(moorDir)/lib -lmoody -o $@

turbsim: turb_lib fix_build_dir
	$(FC) $(ALL_OBJ) $(OUTDIR)/native/*.o -ldl -o TurbSim

crunch: crunch_lib fix_build_dir
	$(FC) $(ALL_OBJ) $(OUTDIR)/native/*.o -ldl -o Crunch

$(SFUNC_NAME): nwtc_lib wind aero fast simulink fix_build_dir
	$(FC) $(LFLAGS) $(OUTDIR)/*.o $(OUTDIR)/simulink/*.o -o $@

#DISCON.o: DISCON.f90
#	$(FC) -fPIC -c $< -o $@
DISCON.o:
	$(FC) -fPIC -c $(TURBINE_PATH)$(TURBINE_FOLDER)/DISCON.f90 -o $(TURBINE_PATH)$(TURBINE_FOLDER)/$@

#DISCON.so: DISCON.o
#	$(FC) -shared $< -o $@
DISCON.so: DISCON.o
	$(FC) -shared $(TURBINE_PATH)$(TURBINE_FOLDER)/DISCON.o -o ./$@ #$(TURBINE_PATH)$(TURBINE_FOLDER)/$@

fix_build_dir:
	@touch $(OUTDIR)/SysMatlab.o
	@touch $(OUTDIR)/SysGnuLinux.o
	@mkdir -p $(OUTDIR)/simulink
	@mkdir -p $(OUTDIR)/native
	@mv $(OUTDIR)/SysMatlab.o $(OUTDIR)/simulink/SysMatlab.o
	@mv $(OUTDIR)/SysGnuLinux.o $(OUTDIR)/native/SysGnu.o

test_cases:
	@mkdir -p $(TESTDIR)/simulink
	@cp -r $(TURBINE_PATH)$(TURBINE_FOLDER) $(TESTDIR)/simulink
	@cp $(SFUNC_NAME) $(TESTDIR)/simulink/$(TURBINE_FOLDER)
	@cp fast/Simulink/Samples/OpenLoop.mdl $(TESTDIR)/simulink/$(TURBINE_FOLDER)
	@cp fast/Simulink/*.m $(TESTDIR)/simulink/$(TURBINE_FOLDER)
	@mkdir -p $(TESTDIR)/commandline
	@cp -r $(TURBINE_PATH)$(TURBINE_FOLDER) $(TESTDIR)/commandline
	@cp FAST $(TESTDIR)/commandline/$(TURBINE_FOLDER)

nwtc_lib:
	$(MAKE) -C $(NWTC_LIB)/source

wind: nwtc_lib
	$(MAKE) -C $(WIND_LIB)/Source

aero: nwtc_lib wind
	$(MAKE) -C $(AERO_LIB)/Source

fast: nwtc_lib wind aero
	$(MAKE) -C $(FAST_LIB)/Source

simulink: nwtc_lib wind aero fast
	$(MAKE) -C $(SIM_LIB)/Source

turb_lib: nwtc_lib
	$(MAKE) -C $(TURBSIM_LIB)/Source/RNG
	$(MAKE) -C $(TURBSIM_LIB)/Source/NetLib/FFTPACK
	$(MAKE) -C $(TURBSIM_LIB)/Source/NetLib/LAPACK/BLAS
	$(MAKE) -C $(TURBSIM_LIB)/Source/NetLib/LAPACK
	$(MAKE) -C $(TURBSIM_LIB)/Source

crunch_lib: nwtc_lib
	$(MAKE) -C $(CRUNCH_LIB)/Source


.PHONY: clean veryclean
clean:
	$(MAKE) clean -C $(NWTC_LIB)/source; \
	$(MAKE) clean -C $(WIND_LIB)/Source; \
	$(MAKE) clean -C $(AERO_LIB)/Source; \
	$(MAKE) clean -C $(FAST_LIB)/Source; \
	$(MAKE) clean -C $(TURBSIM_LIB)/Source; \
	$(MAKE) clean -C $(TURBSIM_LIB)/Source/RNG; \
	$(MAKE) clean -C $(TURBSIM_LIB)/Source/NetLib/FFTPACK; \
	$(MAKE) clean -C $(TURBSIM_LIB)/Source/NetLib/LAPACK/BLAS; \
	$(MAKE) clean -C $(TURBSIM_LIB)/Source/NetLib/LAPACK; \
	$(MAKE) clean -C $(SIM_LIB)/Source;
	rm -rf $(PROG_NAME) $(SFUNC_NAME) DISCON.o DISCON.so
veryclean: clean
	rm -rf build include
