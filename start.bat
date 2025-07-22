@echo off
REM Définit le chemin du script PowerShell sur le Bureau de l’utilisateur courant
set "PS_SCRIPT=%USERPROFILE%\Desktop\W11Debloater-arm-ctrl.ps1"

REM Met la politique d’exécution à RemoteSigned pour autoriser les scripts locaux
powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force"

REM Lance le script PowerShell en mode administrateur
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File \"%PS_SCRIPT%\"' -Verb RunAs"