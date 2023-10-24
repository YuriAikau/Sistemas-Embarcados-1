@if "%1" == "compile" call .\MAKE\comp1.bat
@if "%1" == "adjust" call .\MAKE\comp2.bat
@if "%1" == "update" call .\MAKE\update.bat %2
@if "%1" == "clear" call .\MAKE\clear.bat