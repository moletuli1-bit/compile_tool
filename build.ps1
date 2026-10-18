g++ -Wall -Wextra -g -std=c++20 file_finder.cpp -o file_finder.exe
if ($LASTEXITCODE -eq 0) { Copy-Item .\file_finder.exe C:\tools\ -Force }
