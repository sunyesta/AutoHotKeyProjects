#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
; SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force


CoordMode,Pixel,Screen ;set coord mode for pixels to screen (not window)
CoordMode,Mouse,Screen ;set coord mode for mouse to screen

#Include ../../Libraries/Gdip.ahk
#Include ../../Libraries/obj2str.ahk
#Include ../../Libraries/Point.ahk

global rows := 5
global cols := 10

global MIN_TIME := 100

global researchBtnPt := new Point(200, 825)
global researchCellPt := new Point(200, 710)
global garbagePt := new Point(575, 345)

getPixelFromInventoryIndex(i){
	startPt := new Point(50, 50)
	step := 58
	
	
	
	r := Floor(i / cols)
	c := Mod(i,cols)

	x := startPt.X + (c * step)
	y := startPt.Y + (r * step)
	;msgBox, % "pt" . new Point(x,y).toString()
	return new Point(x, y)
}

#S::
    i=0
	while(i<rows*cols){
		itemPt := getPixelFromInventoryIndex(i)

        Send {Shift down}
        sleep, MIN_TIME
		MouseClick, left, itemPt.X, itemPt.Y
		sleep, MIN_TIME
        Send {Shift up}
        sleep, MIN_TIME

		MouseClick, left, researchBtnPt.X, researchBtnPt.Y
        sleep, 1500
		i+=1
	}
    
	return



!F2::
	ExitApp
	return
	
	