INCDRS = -I../include/

SRCFLS = ../source/p1271_macros.s ../source/p1271_spaces.s ../source/p1271_5brwhash_on-the-fly.s main_on-the-fly.c

OBJFLS = ../source/p1271_macros.o ../source/p1271_spaces.o ../source/p1271_5brwhash_on-the-fly.o main_on-the-fly.o
EXE    = p1271-fly

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




 


