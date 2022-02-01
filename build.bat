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
    set GOARCH=386
) else (
    set CC=%ROOTDIR%\mingw64\bin\x86_64-w64-mingw32-gcc
)

set CGO_ENABLED=1
set GOOS=windows
set GOPATH=%ROOTDIR%\gopath
set GOROOT=%ROOTDIR%\go

pushd %BUILDDIR%
%CC% %ROOTDIR%\crashc\lib.c -shared -g -o crashc.dll || exit /b
popd

go\bin\go build -buildmode c-shared -o %BUILDDIR%\wrapgo.dll %ROOTDIR%\wrapgo\wrap.go || exit /b

pushd %BUILDDIR%
%CC% %ROOTDIR%\main\main.c -g -o main.exe || exit /b
popd

echo DONE
