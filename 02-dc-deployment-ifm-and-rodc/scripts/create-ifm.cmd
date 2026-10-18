@echo off
REM ==========================================================
REM  Create Install From Media (IFM) on an existing writable DC
REM  Output folder must be empty or not yet exist.
REM ==========================================================
ntdsutil "activate instance ntds" "ifm" "create sysvol full C:\IFM" quit quit
