CC = gcc
LD = gcc
OBJS = main.o
TARGET = task
CFLAGS = -Wall -Werror

all: $(TARGET)

task: main.c
	$(LD) -o task main.c $(CFLAGS)

%.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS)

.PHONY: clean

clean:
	rm -f *.o $(TARGET)
