@echo off

powershell.exe -ExecutionPolicy RemoteSigned %~dp0convert.ps1 '%1' %2 %3 '%4' %5

@echo on