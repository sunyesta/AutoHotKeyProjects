#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
; SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force

CoordMode,Pixel,Screen ;set coord mode for pixels to screen (not window)
CoordMode,Mouse,Screen ;set coord mode for mouse to screen


global lastRecipeButtonX := 1025
global lastRecipeButtonY := 415

; --------------- Main Code ---------------
Pause, Toggle ;start off

global needed := 35
global cookTime := 4

cookTime*=1000

while(needed>0){

	Send,{f}
	sleep 500
	Send,{f}
	sleep cookTime
	Send,{f}
	
	needed--
	sleep 500
}

return

; --------------- key switches ---------------

!F2::
	Pause, Toggle
	return