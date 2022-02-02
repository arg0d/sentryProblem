package main

//extern void CrashC_Start();
import "C"

import (
	"fmt"
)

//export WrapGo_Start
func WrapGo_Start() {
	fmt.Println("WrapGo_Start()")
	C.CrashC_Start();
}

func main() {}
