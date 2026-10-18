param(
    [Parameter(Mandatory)][string]$Name,
    [string]$Executable = $Name
)

g++ -Wall -Wextra -g -std=c++20 "$Name.cpp" -o "$Executable.exe"
if ($LASTEXITCODE -eq 0) { Write-Host "Build succeeded..." }else{Write-Host "Build failed..."}
