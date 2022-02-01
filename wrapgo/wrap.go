package main

import (
	"C"
	"fmt"
	"syscall"
)

//export WrapGo_Start
func WrapGo_Start() {
	fmt.Println("WrapGo_Start()")

	library, err := syscall.LoadLibrary("crashc.dll")
	if err != nil {
		panic(err)
	}
	defer syscall.FreeLibrary(library)

	proc, err := syscall.GetProcAddress(library, "CrashC_Start")
	if err != nil {
		panic(err)
	}

	syscall.Syscall(proc, 0, 0, 0, 0)
}

func main() {}
