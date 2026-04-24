@echo on
setlocal enabledelayedexpansion

@REM Create conda.rb from default and switch to full-core
copy /Y build_config\default.rb build_config\conda.rb
if %ERRORLEVEL% neq 0 exit /b 1
sed -i "s|conf.toolchain|conf.toolchain :visualcpp|" build_config\conda.rb
if %ERRORLEVEL% neq 0 exit /b 1
sed -i "s|conf.gembox 'default'|conf.gembox 'full-core'|" build_config\conda.rb
if %ERRORLEVEL% neq 0 exit /b 1

@REM Export MRUBY_CONFIG for the build
set "MRUBY_CONFIG=build_config\conda.rb"
if %ERRORLEVEL% neq 0 exit /b 1

@REM Run build and tests (use ruby -S rake to ensure using the Ruby in PATH)
ruby -S rake all test
if %ERRORLEVEL% neq 0 exit /b 1

if not exist "%LIBRARY_PREFIX%\lib" mkdir "%LIBRARY_PREFIX%\lib"
if %ERRORLEVEL% neq 0 exit /b 1
copy /Y build\host\lib\* "%LIBRARY_PREFIX%\lib\"
if %ERRORLEVEL% neq 0 exit /b 1

if not exist "%LIBRARY_PREFIX%\bin" mkdir "%LIBRARY_PREFIX%\bin"
if %ERRORLEVEL% neq 0 exit /b 1
copy /Y build\host\bin\* "%LIBRARY_PREFIX%\bin\"
if %ERRORLEVEL% neq 0 exit /b 1

if not exist "%LIBRARY_PREFIX%\mrbgems" mkdir "%LIBRARY_PREFIX%\mrbgems"
if %ERRORLEVEL% neq 0 exit /b 1
if not exist "%LIBRARY_PREFIX%\mrblib" mkdir "%LIBRARY_PREFIX%\mrblib"
if %ERRORLEVEL% neq 0 exit /b 1
if not exist "%LIBRARY_PREFIX%\include" mkdir "%LIBRARY_PREFIX%\include"
if %ERRORLEVEL% neq 0 exit /b 1
xcopy /E /I /Y build\host\mrbgems "%LIBRARY_PREFIX%\mrbgems"
if %ERRORLEVEL% neq 0 exit /b 1
xcopy /E /I /Y build\host\mrblib "%LIBRARY_PREFIX%\mrblib"
if %ERRORLEVEL% neq 0 exit /b 1
xcopy /E /I /Y include "%LIBRARY_PREFIX%\include"
if %ERRORLEVEL% neq 0 exit /b 1
