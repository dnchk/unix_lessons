CC = g++
LD = g++
OBJS = main.o
TARGET = task
CFLAGS = -Wall -Werror

all: $(TARGET)

$(TARGET): $(OBJS)
	$(LD) -o $@ $^ --std=c++17 -lstdc++fs $(CFLAGS)

%.o: %.cpp
	$(CC) -c -o $@ $< $(CFLAGS)

.PHONY: clean

clean:
	rm -f *.o $(TARGET)
