# test-detect

This should look a great deal like Atomic Red Team, because it is heavily inspired by Atomic Red Team. 

## Goals:
- Use patterns and design methods implemented in Atomic Red Team
- Extend functionality within tests, to allow for dynamic input arguments that are defined within the test. 
    - See below for more detail on input argument types 'static.', 'multi.' and 'powershell.'
- Native powershell as much as possible. 
    - Remove YAML/ .net YAML requirements


## Non Goals:
- Replace Atomic Red Team
- Substantially rewrite core functionality of Atomic Red Team


## Update: Inputs
### Static input argument type
This is a name update from the standard input argument used in Atomic Red Team. Specify with 'static.' prefix.
### Multi input argument type
This is a new concept for input arguments - given an array of values, when the test is invoked one of the values with be selected with the `Get-Random` cmdlet. Specify with 'multi.' prefix.
### PowerShell input argument type
This is a new concept for input arguments - specify a powershell command to be run, the output will be used as the argument value. Command will be run with `Invoke-Expression`. Specify with 'powershell.' prefix.

## Update: Sequencing
### Campaigns
A Campaign is a collection of tests - campaigns can specify the order in which tests are run, as well as the ordering method for cleanup commands.
### Test Ordering
Each test will now have a 'process order' field, where an interger can be specified. Tests will be run in order, smallest to largest.
### Cleanup Ordering
Cleanup commands can be run in one of three ways:
- Default - cleanup command is run directly after the command specified in the test. For example, in a campaign with 3 tests, default sequencing would look like
```
command A
cleanup command A
command B
cleanup command B
command C
cleanup command C
```
- FIFO - (First In, First Out) cleanup commands are run in the same order as commands were run, though the first cleanup command does not start until the final command has finished. For example, in a campaign with 3 tests, FIFO sequencing would look like
```
command A
command B
command C
cleanup command A
cleanup command B
cleanup command C
```
- FILO - (First In, Last Out) cleanup commands are run in the reverse order from how the commands were run. For example, in a campaign with 3 tests, FILO sequencing would look like
```
command A
command B
command C
cleanup command C
cleanup command B
cleanup command A
```