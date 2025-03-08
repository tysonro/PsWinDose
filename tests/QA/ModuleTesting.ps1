<#
A simple reference to help testing the module locally.
#>

# Import the module
Import-Module ".\source\PsWindose.psd1" -Force

# Import the built module
Import-Module ".\buildoutput\PsWindose\*\pswindose.psd1" -Force
