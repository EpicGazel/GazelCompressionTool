@echo off

for /F "delims=" %%A in ('wmic cpu get NumberOfCores /format:value ^| find "NumberOfCores"') do set %%A
set /a "numThreads=%NumberOfCores%*2"

if [%1]==[] goto UserInput
if %1==-C set "inputFile=%2" & set "menuOption=C" & goto Compress
if %1==-D set "inputFile=%2" & set "menuOption=D" & goto Decompress

:UserInput
set /p "menuOption=(C)ompress, (D)ecompress, (Q)uit: "
if %menuOption%==Q exit


set /p "inputFile=Enter file path: "
::set /p "numThreads=Enter number of threads: "

if %menuOption%==C goto Compress
if %menuOption%==D goto Decompress

echo Invalid Menu Option
pause
exit

:Compress
:: set /p "outputFile=Enter output file name (no extension): "
:: Removes the extension after the dot (.), ex: "waffles.zip" becomes "waffles." (dot included)
set "extension=%inputFile:*.=%"
call set "outputFile=%%inputFile:%extension%=%%"

echo Running precomp
precomp.exe -cn -o"precompiledfile.pcf" %inputFile%

echo Running zpaq
zpaq add "%outputfile%zpaq" "precompiledfile.pcf" -m5 -t%numThreads%

goto Cleanup

:Decompress
echo Unpacking zpaq
zpaq x %inputFile% -t%numThreads%

echo Recompiling pcf
precomp -r "precompiledfile.pcf"

goto Cleanup

:Cleanup
if %menuOption%==C echo Compression completed, output %outputFile%zpaq
if %menuOption%==D echo Decompression completed.

echo Cleaning up
del "precompiledfile.pcf"

::Special Cleanup for auto extraction, deletes archive or zip
if [%1]==[] pause & exit
if %1==--cleanup goto CleanInstall

if [%3]==[] pause & exit
if %3==--cleanup goto CleanAll
pause & exit

:CleanInstall
(goto) 2>nul & del precomp.exe zpaq.exe gct.bat
pause & exit

:CleanAll
::Cleans up after compressing/decompressing
del %inputFile% precomp.exe zpaq.exe
(goto) 2>nul & del gct.bat
pause & exit
p