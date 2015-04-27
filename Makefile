CC=ozc
CFLAGS=-c

all:
	$(CC) $(CFLAGS) agent.oz
	
clean:
	rm *.ozf