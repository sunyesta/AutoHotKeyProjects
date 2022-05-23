#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
; SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force

CoordMode,Pixel,Screen ;set coord mode for pixels to screen (not window)
CoordMode,Mouse,Screen ;set coord mode for mouse to screen


#Include ../Libraries/Gdip.ahk
#Include ../Libraries/obj2str.ahk
#Include ../Libraries/Point.ahk

; --------------- User Variables ---------------

global BUTTON_COLOR := 0xe03997
global buttonLoc := new Point(0, 0)
buttonLoc.X := 5
buttonIsVisible(){

	PixelSearch, foundX, foundY, 0,0 , A_ScreenWidth, A_ScreenHeight, BUTTON_COLOR, 0, RGB, Fast 
	
	if(ErrorLevel == 0){
        buttonLoc.set(foundX, foundY)
		return true
		
	}
	
	return false

}

#J:: ; windows + j
	
	while(true){
        if(buttonIsVisible()){
            pointClick(buttonLoc)
            ; msgBox, "found it!"
        }else{
            ; msgBox,"nope"
        }

        Sleep, 1000
    }
    
	return



