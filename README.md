# compile

A small PowerShell script that compiles a C++ source file with `g++` and installs the resulting executable into a central tools folder, so you can run it from anywhere in your terminal.

## Usage

```powershell
compile <source_name> [executable_name]
```

- `source_name`: the name of your `.cpp` file, **without** the extension.
- `executable_name` *(optional)*: the name for the built `.exe`, without the extension. Defaults to `source_name`.

### Examples

```powershell
compile file_finder          # builds file_finder.cpp -> file_finder.exe
compile file_finder ff       # builds file_finder.cpp -> ff.exe
```

If the build succeeds, the executable is copied to `C:\tools\` (overwriting any previous version). If it fails, the compiler errors are shown and `Build failed...` is printed, and nothing is copied.

## Requirements

- Windows with PowerShell
- `g++` installed and available on your `PATH` (for example via [MSYS2](https://www.msys2.org/) or MinGW-w64)
  - Check with: `g++ --version`
- A `C:\tools` folder that is on your system `PATH`

## Installation

1. **Create the tools folder** (skip if it already exists):

   ```powershell
   mkdir C:\tools
   ```

2. **Add it to your PATH** (skip if it's already there), then restart your terminal:

   ```powershell
   [Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\tools", "User")
   ```

3. **Copy the script into the tools folder:**

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

The script has two steps:

1. **Compile** the source with `g++`, using the flags `-Wall -Wextra -g -std=c++20`:
   - `-Wall -Wextra` enable extra compiler warnings
   - `-g` includes debug information
   - `-std=c++20` uses the C++20 standard
2. **Install**: if `g++` exited successfully (`$LASTEXITCODE` is `0`), copy the executable to `C:\tools\`.

The built `.exe` also stays in the folder you ran the command from, which is handy for local testing.

## Notes

- Don't include the `.cpp` extension in the arguments. The script adds it for you, so `compile file_finder.cpp` would look for `file_finder.cpp.cpp`.
- The install location (`C:\tools`) is hardcoded. To use a different folder, edit the `Copy-Item` line in `compile.ps1`.

## Example project

`file_finder` is a small C++ tool built with this script. Build and install it with:

```powershell
compile file_finder
```

Then run `file_finder` from any terminal location.
