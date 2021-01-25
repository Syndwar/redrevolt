del /f /a /q _result
rd /s /q _result
lua5.1.exe -i "_atlas_script.lua" %1
pause