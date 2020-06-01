CC = g++
LD = g++
OBJS = main.o
TARGET = task
CFLAGS = -Wall -Werror

all: $(TARGET)

task: main.cpp
	$(LD) --std=c++17 -o task main.cpp -lstdc++fs $(CFLAGS)

%.o: %.cpp
	$(CC) -c -o $@ $< $(CFLAGS)

.PHONY: clean

clean:
	rm -f *.o $(TARGET)
