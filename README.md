# test-detect

This should look a great deal like Atomic Red Team, because it is heavily inspired by Atomic Red Team. 

## Goals:
- Use patterns and design methods implemented in Atomic Red Team
- Extend functionality within tests, to allow for dynamic input arguments that are defined within the test. 
    - See below for more detail on input argument types 'static.', 'multi.' and 'powershell.'


## Non Goals:
- Replace Atomic Red Team
- Substantially rewrite core functionality of Atomic Red Team


## Updated Inputs
### Static input argument type
This is a name update from the standard input argument used in Atomic Red Team. Specify with 'static.' prefix.
### Multi input argument type
This is a new concept for input arguments - given an array of values, when the test is invoked one of the values with be selected with the `Get-Random` cmdlet. Specify with 'multi.' prefix.
### PowerShell input argument type
This is a new concept for input arguments - specify a powershell command to be run, the output will be used as the argument value. Command will be run with `Invoke-Expression`. Specify with 'powershell.' prefix.
