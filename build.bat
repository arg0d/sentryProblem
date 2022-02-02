setlocal

set ROOTDIR=%cd%
set BUILDDIR=%ROOTDIR%\build

if exist %BUILDDIR% (
    rmdir /s /q %BUILDDIR% || exit /b
)
mkdir %BUILDDIR% || exit /b

if not exist go (
    powershell -command "$ProgressPreference = 'SilentlyContinue'; Start-BitsTransfer -Source https://dl.google.com/go/go1.17.6.windows-amd64.zip -Destination %BUILDDIR%\go.zip" || exit /b
    powershell -command "$ProgressPreference = 'SilentlyContinue'; Expand-Archive %BUILDDIR%\go.zip %ROOTDIR%" || exit /b
)

if "%1" == "x86" (
    set CC=%ROOTDIR%\mingw32\bin\i686-w64-mingw32-gcc
    set AR=%ROOTDIR%\mingw32\bin\ar
    set GOARCH=386
) else (
    set CC=%ROOTDIR%\mingw64\bin\x86_64-w64-mingw32-gcc
    set AR=%ROOTDIR%\mingw64\bin\ar
)

set CGO_ENABLED=1
set GOOS=windows
set GOPATH=%ROOTDIR%\gopath
set GOROOT=%ROOTDIR%\go
set CGO_LDFLAGS=-L%BUILDDIR%\ -lcrashc

pushd %BUILDDIR%
%CC% %ROOTDIR%\crashc\lib.c -c -g -o crashc.o || exit /b
%AR% rcs crashc.lib crashc.o || exit /b
popd

go\bin\go build -buildmode c-archive -o %BUILDDIR%\wrapgo.lib %ROOTDIR%\wrapgo\wrap.go || exit /b

pushd %BUILDDIR%
%CC% %ROOTDIR%\main\main.c -g -o main.exe -L. -lwrapgo -lcrashc || exit /b
popd

echo DONE
