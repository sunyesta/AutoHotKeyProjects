#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
; SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force

CoordMode,Pixel,Screen ;set coord mode for pixels to screen (not window)
CoordMode,Mouse,Screen ;set coord mode for mouse to screen



global lastRecipieButtonX = 1025
global lastRecipieButtonY = 415



; --------------- Main Code ---------------
Pause, Toggle ;start off

while(true){
	
	
	if(colorCheck(clickNowColor)){
		Click
	}
	
	sleep 500
}

; --------------- key switches ---------------

!F2::
	Pause, Toggle
	return