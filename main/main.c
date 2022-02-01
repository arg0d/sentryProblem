#include <Windows.h>

#include <stdio.h>

LONG WINAPI ExceptionHandler(EXCEPTION_POINTERS *exception_pointers) {
  printf("OnUnhandledException()\n");
  return EXCEPTION_CONTINUE_SEARCH;
}

int main() {
  SetUnhandledExceptionFilter(ExceptionHandler);

  HMODULE library = LoadLibraryA("wrapgo.dll");
  if (library == NULL) {
    printf("failed to load wrapgo.dll\n");
    return 1001;
  }

  typedef void (*funcType)();
  funcType wrapgo_start = (funcType)(GetProcAddress(library, "WrapGo_Start"));
  if (wrapgo_start == NULL) {
    printf("function not found WrapGo_Start()\n");
    return 1002;
  }

  wrapgo_start();

  return 0;
}
