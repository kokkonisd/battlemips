CC = gcc
CFLAGS = -Wall -g
OBJECTS = main.o battleshipsJeu.o battleshipsIO.o coups.o placeBateaux.o

battleships : $(OBJECTS)
	$(CC) $(CFLAGS) $(OBJECTS) -o battleships
	rm -f $(OBJECTS)

%.o : %.c
	$(CC) $(CFLAGS) -c $<

%.c : %.h

clean :
	rm -f battleships *.o