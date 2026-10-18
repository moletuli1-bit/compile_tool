# compile

A small PowerShell script that compiles a C++ source file with `g++` and puts the executable in the folder you ran it from. Run it from your project folder and the `.exe` ends up right next to your `.cpp`.

## Usage

```powershell
compile <source_name> [executable_name]
```

- `source_name`: the name of your `.cpp` file, **without** the extension.
- `executable_name` *(optional)*: the name for the built `.exe`, without the extension. Defaults to `source_name`.

Run the command from the folder that contains your source file.

### Examples

```powershell
cd C:\path\to\file_finder
compile file_finder          # builds file_finder.cpp -> file_finder.exe
compile file_finder ff       # builds file_finder.cpp -> ff.exe
```

On success it prints `Build succeeded...`. On failure it shows the compiler errors and prints `Build failed...`.

Compiler warnings (such as an unused parameter) are shown but don't stop the build.

## Requirements

- Windows with PowerShell
- `g++` installed and available on your `PATH` (for example via [MSYS2](https://www.msys2.org/) or MinGW-w64)
  - Check with: `g++ --version`
- A folder for your scripts (this README uses `C:\tools`) that is on your system `PATH`, so `compile` works from any directory

## Installation

You only install the script itself. Programs you build stay in their own project folders.

1. **Create a folder for your scripts** (skip if it already exists):

   ```powershell
   mkdir C:\tools
   ```

2. **Add it to your PATH** (skip if it's already there), then restart your terminal:

   ```powershell
   [Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\tools", "User")
   ```

3. **Copy the script into that folder:**

   ```powershell
   Copy-Item .\compile.ps1 C:\tools\ -Force
   ```

4. **Verify it's found:**

   ```powershell
   Get-Command compile
   ```

   If something other than your script shows up, another command already uses that name. Rename the script (for example `cbuild.ps1`) and use that name instead.

### Execution policy

If PowerShell refuses to run the script with an error like *"running scripts is disabled on this system"*, allow locally created scripts for your user:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

## How it works

1. **Compile** the source with `g++`, using the flags `-Wall -Wextra -g -std=c++20`:
   - `-Wall -Wextra` enable extra compiler warnings
   - `-g` includes debug information
   - `-std=c++20` uses the C++20 standard
2. **Report the result**: if `g++` exited successfully (`$LASTEXITCODE` is `0`), print a success message. Otherwise, print a failure message.

`g++` runs in whatever directory you're currently in, so the source is read from there and the executable is written there.

## Notes

- Don't include the `.cpp` extension in the arguments. The script adds it for you, so `compile file_finder.cpp` would look for `file_finder.cpp.cpp`.
- The executable is created in your **current directory**. That's the same as the source's folder as long as you run the command from inside the project folder.

## Example project

`file_finder` is a small C++ tool built with this script:

```powershell
cd C:\path\to\file_finder
compile file_finder
.\file_finder.exe
```
