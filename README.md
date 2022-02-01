# Problem

CGO breaks [SetUnhandledExceptionFilter](https://docs.microsoft.com/en-us/windows/win32/api/errhandlingapi/nf-errhandlingapi-setunhandledexceptionfilter)
API on Windows x64. Automated crash reporting tools, such as Sentry, use
the aforementioned API to capture SEH exceptions and send them to
backend for processing. The reports are converted into stacktraces and
aggregated. This allows the developer of an application to monitor
stability of their product and fix crashes as their appear on the
dashboard.

Because of this CGO issue, Go becomes very unnatractive for any serious
client application development on Windows. Fixing this issue would make
Go much more suited for client application development.

# Architecture of this sample

This program is broken down into 3 binaries: `main.exe`, `wrapgo.dll`
and `crashc.dll`. `main.exe` calls into `wrapgo.dll`, which in turn
forwards the call to `crashc.dll`. `crashc.dll` crashes the program. In
this setup, Go is the middle man between the main program, and another
library that is crashing.

# Steps to reproduce

- **Get a Windows installation.** Since this is a Windows issue, you
    must have a Windows installation to be able to test it. Its
    possible to build on Linux, but since testing must be done on
    Windows, the provided build script is written using Windows Batch.
 
- **Clone the source**.

        git clone git@github.com:arg0d/sentryProblem.git

- **Get MinGW compilers**. Download prebuilt compilers from [here]
    (https://sourceforge.net/projects/mingw-w64/files/). Get the latest
    version `MinGW-W64 GCC-8.1.0`. For Windows x64, get
    `x86_64-win32-seh`. For Windows x86, get `i686-win32-sjlj`. Extract
    the contents of archives into `sentryProblem/mingw64` and
    `sentryProblem/mingw32`

- **Build**.
        
        build.bat

- **Run**.
        
        run.bat

- **Check the output**. After running the program, observe that string
    `OnUnhandledException` is missing.

        C:\workspace\sentryBugReport\build>main.exe
        WrapGo_Start()
        CrashC_Start()

# Works on Windows x86

`SetUnhandledExceptionFilter` seems to be working fine when using x86.
To test that, do the following:

- Comment out the contents of function `initExceptionHandler` at
  `sentryProblem/go/src/runtime/signal_windows.go`. The exception
  handling implementation is overriding the previously set unhandled
  exception filter.

- **Build.**

        build.bat x86

- **Run.**

        run.bat

- **Check the output**. After running the program, observe that
    `OnUnhandledException` is present.

        C:\workspace\sentryBugReport\build>main.exe
        WrapGo_Start()
        CrashC_Start()
        OnUnhandledException()
