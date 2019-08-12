@echo off 
title Memoria Flash . BSF Hack Team 
color 1E 
@echo ---------------------------------------------- 
@echo ---- REPARACION DE FICHEROS MEMORIA FLASH ---- 
@echo ---------------------------------------------- 
@echo Status : Cambiando Atributo de Carpetas 
Attrib /d /s -r -h -s *.* 
@echo ---------------------------------------------- 
@echo Status : Eliminado Accesos Directos 
if exist *.lnk del *.lnk 
@echo ---------------------------------------------- 
@echo Status : Eliminado Autorun 
if exist autorun.inf del autorun.inf 
@echo ---------------------------------------------- 
@echo Status : Cambiando propiedades 
attrib -a -s -h -r /s /d 
@echo ----------------------------------------------
@echo Status : Eliminando System Volume Information
if exist "System Volume Information" rmdir "System Volume Information" /s /q
@echo ----------------------------------------------
@echo Status : Eliminando 1.BAT
if exist "1.bat" rmdir "1.bat" /s /q
@echo ---------------------------------------------- 
@echo Status : Operacion Terminada 
@echo ---------------------------------------------- 
@echo ---------------------------------------------- 
@echo Hacked By Elvis
@echo ---------------------------------------------- 
@echo ---------------------------------------------- 
pause 