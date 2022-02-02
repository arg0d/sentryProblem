#include <Windows.h>

#include <stdio.h>

extern void WrapGo_Start();

LONG WINAPI ExceptionHandler(EXCEPTION_POINTERS *exception_pointers) {
  printf("OnUnhandledException()\n");
  return EXCEPTION_CONTINUE_SEARCH;
}

int main() {
  SetUnhandledExceptionFilter(ExceptionHandler);

  WrapGo_Start();

  return 0;
}
