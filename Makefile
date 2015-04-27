#Makefile for compiling the functors.
#Be aware of the ORDER by which you compile the functors.
CC=ozc
CFLAGS=-c

all:
	$(CC) $(CFLAGS) agent.oz
	$(CC) $(CFLAGS) window.oz
	$(CC) $(CFLAGS) list_pokemoz.oz
	$(CC) $(CFLAGS) select_starter.oz
clean:
	rm *.ozf
