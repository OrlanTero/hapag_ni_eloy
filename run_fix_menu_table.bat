@echo off
echo Running SQL script to fix menu table...

REM Change these values to match your SQL Server configuration
set server=localhost
set database=FOS
set username=sa
set password=your_password

REM Run the SQL script
sqlcmd -S %server% -d %database% -U %username% -P %password% -i fix_menu_table.sql

echo.
echo SQL script execution completed.
echo If you see any errors above, please check your SQL Server configuration.
echo.
pause 