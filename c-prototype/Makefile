CC = gcc
CFLAGS = -Wall -g -std=c99
OBJECTS = main.o battleshipsJeu.o battleshipsIO.o

all : battleships

battleships : $(OBJECTS)
	$(CC) $(CFLAGS) $(OBJECTS) -o battleships
	rm -f $(OBJECTS)

%.o : %.c
	$(CC) $(CFLAGS) -c $<

%.c : %.h

clean :
	rm -f battleships *.o
