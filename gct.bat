@echo off
if %1==-C set "inputFile=%2" & set "menuOption=C" & goto Compress
if %1==-D set "inputFile=%2" & set "menuOption=D" & goto Decompress
set /p "menuOption=(C)ompress, (D)ecompress, (Q)uit: "

if %menuOption%==Q exit

set /p "inputFile=Enter file path: "
set /p "numThreads=Enter number of threads: "

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
zpaq x %inputFile% -t12

echo Recompiling pcf
precomp -r "precompiledfile.pcf"

goto Cleanup

:Cleanup
echo Cleaning up
del "precompiledfile.pcf"

if %menuOption%==C echo Compression completed, output %outputFile%zpaq
if %menuOption%==D echo Decompression completed.

::Special Cleanup for auto extraction, deletes archive or zip
if %3==--cleanup del %inputFile%

::Cleans up after compressing/decompressing
if %1==--cleanup (goto) 2>nul & del precomp.exe zpaq.exe gct.bat
if %1==-C (goto) 2>nul & del precomp.exe zpaq.exe gct.bat
if %1==-D (goto) 2>nul & del precomp.exe zpaq.exe gct.bat

pause
exit