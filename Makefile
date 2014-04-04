### compiler selection, (un)comment as appropriate
# The Intel(R) fortran compiler (ifort)
ifeq ($(DEBUG),1)
  FC = ifort
  FCFLAGS = -g -CU -C -traceback -fpe0 -debug -openmp
  LDFLAGS = -openmp
else
  FC = ifort
  FCFLAGS = -O2 -openmp
  LDFLAGS = -O2 -openmp
endif
### The GNU fortran compiler (gfortran)
#ifeq ($(DEBUG),1)
#  FC = gfortran
#  FCFLAGS = -O -g -fbounds-check -Wall -Wunused-parameter -ffpe-trap=invalid -fbacktrace -fdump-core -fopenmp
#  LDFLAGS = -fopenmp
#else
#  FC = gfortran
#  FCFLAGS = -O
#  LDFLAGS = 
#endif
## The PGI fortran compiler (pgf90)
#ifeq ($(DEBUG),1)
#  FC = pgfortran
#  FCFLAGS = -g -mp=nonuma
#  LDFLAGS =
#else
#  FC = pgfortran
#  FCFLAGS = -O2 -mp=nonuma
#  LDFLAGS = -O2
#endif

#### name, objects, libraries, includes
NAME=postg
OBJS= param.o tools_math.o wfnmod.o meshmod.o postg.o atomicdata.o
LIBS=
INCLUDE=
####

BINS=$(NAME)
BINS_dbg=$(NAME)_dbg

%.o: %.f90
	$(FC) -c $(FCFLAGS) $(INCLUDE) -o $@ $<

%.o: %.f
	$(FC) -c $(FCFLAGS) $(INCLUDE) -o $@ $<

%.mod: %.o
	@if [ ! -f $@ ]; then rm $< ; $(MAKE) $< ; fi

# Targets
all: $(BINS)

debug: 
	DEBUG=1 $(MAKE) $(BINS_dbg)

clean:
	rm -f core *.mod *.o 

veryclean:
	rm -f core *.mod *.o

mrproper:
	rm -f core *.mod *.o $(BINS) $(BINS_dbg)

$(NAME): $(OBJS) $(LIBS)
	$(FC) -o $(NAME) $(LDFLAGS) $(OBJS) $(LIBS)

$(NAME)_dbg: $(OBJS) $(LIBS)
	$(FC) -o $(NAME)_dbg $(LDFLAGS) $(OBJS) $(LIBS)

# Object dependencies
# Block automatically generated by makemake.sh. Re-run when dependencies change.
wfnmod.o postg.o : atomicdata.mod
postg.o : meshmod.mod
wfnmod.o postg.o meshmod.o : param.mod
wfnmod.o meshmod.o : tools_math.mod
postg.o : wfnmod.mod

# dummy
dummy: 
	@true
