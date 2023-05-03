INCDRS = -I../include/

SRCFLS = ../source/p1271_macros.s ../source/p1271_powers.s ../source/p1271_spaces.s ../source/p1271_nrBRW_computation_t5.s main_precomp.c

OBJFLS = ../source/p1271_macros.o ../source/p1271_powers.o ../source/p1271_spaces.o ../source/p1271_nrBRW_computation_t5.o main_precomp.o
EXE    = p1271-pre

CFLAGS = -march=native -mtune=native -m64 -O3 -funroll-loops -fomit-frame-pointer

CC     = gcc-10

LL     = gcc-10

$(EXE): $(OBJFLS)
	$(LL) -o $@ $(OBJFLS) -lm -no-pie 

.c.o:
	$(CC) $(INCDRS) $(CFLAGS) -o $@ -c $<

clean:

	-rm $(EXE)
	-rm $(OBJFLS)




 


