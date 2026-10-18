@echo off
REM ==========================================================
REM  Offline Domain Join - example
REM  Replace corp.example.com / SRV01 / paths with your values
REM ==========================================================

REM ---- Step 1: on a domain controller (elevated) ----
REM djoin /provision /domain corp.example.com /machine SRV01 /savefile C:\ODJ\SRV01-odj.txt

REM ---- Step 2: on the target machine (elevated) ----
REM djoin /requestODJ /loadfile C:\SRV01-odj.txt /windowspath %SystemRoot% /localos
REM shutdown /r /t 0

REM ---- Step 3: clean up ----
REM del C:\SRV01-odj.txt     (the blob contains the machine password)
