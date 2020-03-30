CC = gcc
LD = gcc
OBJS = main.o test.o
TARGET = task test
CFLAGS = -Wall -Werror

all: $(TARGET)

task: main.c
	$(LD) -o task main.c $(CFLAGS)

test: test.c
	$(LD) -o test test.c $(CFLAGS)

%.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS)

.PHONY: clean

clean:
	rm -f *.o $(TARGET)
