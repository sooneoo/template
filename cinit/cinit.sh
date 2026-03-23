#!/bin/bash

PROJECT_NAME=${1:-"simple"}

echo "Creating project: $PROJECT_NAME"


mkdir -pv src
mkdir -pv src/include/
mkdir -pv src/include/$PROJECT_NAME
mkdir -pv src/$PROJECT_NAME

cat << EOF > Makefile
CC=gcc


CACHE = .cache
RELEASE = \$(CACHE)/release
TARGET = $PROJECT_NAME

CFLAGS += -Wall -Wextra -pedantic
CFLAGS += -O2
CFLAGS += -Isrc/include/

LIBS += 


OBJS += \$(CACHE)/main.o


all: build


build: env \$(RELEASE)/\$(TARGET)


\$(RELEASE)/\$(TARGET): \$(OBJS)
	\$(CC) \$(OBJS) \$(LIBS) -o \$(RELEASE)/\$(TARGET)


\$(CACHE)/main.o: src/$PROJECT_NAME/main.c
	\$(CC) \$(CFLAGS) -c \$< -o \$@


.PHONY: exec clean env


exec: build
	\$(RELEASE)/\$(TARGET)


clean:
	rm -rvf \$(CACHE)


env: 
	mkdir -pv \$(CACHE)
	mkdir -pv \$(RELEASE)


EOF


if [ ! -f main.c ]; then
    cat << EOF > src/$PROJECT_NAME/main.c
#include <stdio.h>
#include <stdlib.h>


int main(void) {
    printf("program exit..\\n");
    return EXIT_SUCCESS;
}


EOF
fi

echo "project prepared"





