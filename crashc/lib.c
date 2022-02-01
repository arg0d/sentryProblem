#include <stdio.h>

void CrashC_Start() {
    printf("CrashC_Start()\n");
    *(volatile int*)0=0;
}
