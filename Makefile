CC = gcc
CFLAGS = -g -Wall -Wextra -O2
TARGET = ms_comp

all: $(TARGET)

$(TARGET): main.o utils.o ms.o
	$(CC) $(CFLAGS) -o $(TARGET) main.o utils.o ms.o

main.o: main.c
	$(CC) $(CFLAGS) -c main.c

utils.o: utils.c utils.h
	$(CC) $(CFLAGS) -c utils.c

ms.o: ms.c ms.h
	$(CC) $(CFLAGS) -c ms.c

clean:
	rm -f *.o $(TARGET)

run:
	./$(TARGET)