#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
; SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force

global needed = 20


global clsFarmEditorButX := 1345
global clsFarmEditorButY := 170

global frstInvSltX := 40
global frstInvSltY := 155

global placeButtonX := 1020
global placeButtonY := 500


; --------------- Main Code ---------------
Pause, Toggle ;start off



while(needed>0){
	mousemove, frstInvSltX, frstInvSltY
	Click
	sleep 500
	
	
	mousemove, placeButtonX, placeButtonY
	Click
	sleep 500
	
	mousemove, clsFarmEditorButX, clsFarmEditorButY
	Click
	sleep 500
	
	needed--
}

return

; --------------- key switches ---------------

!F2::
	Pause, Toggle
	return

