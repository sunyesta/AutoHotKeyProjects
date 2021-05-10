#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
; SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force

CoordMode,Pixel,Screen ;set coord mode for pixels to screen (not window)
CoordMode,Mouse,Screen ;set coord mode for mouse to screen


; --------------- User Variables ---------------



global goodPt := new Point(708,700)

global buttonLoc := new Point(800,635)

; --------------- Point Class ---------------

class Point{
	__New(x,y){
		this.X := x
		this.Y := y
		;msgBox, % "creating: " . this.toString()
		return this
	}
	
	__Delete(){
		;msgBox, % "deleting: " . this.toString()
	}
	
	toString(){
		return % "" . this.x . ", " . this.y
	}
}

; --------------- functions ---------------




mouseToPt(pt){
	mousemove, pt.X, pt.Y
}

; --------------- Main Code ---------------


Pause, Toggle ;start off
;sleep 100000
while(true){
	send ^r
	
	mousemove, buttonLoc.X, buttonLoc.Y
	Click
	
	sleep 100
	
	PixelGetColor, colorAtPixel, goodPt.X, goodPt.Y, RGB
	if(colorAtPixel=0x767676){
		;SoundPlay, .\Alarm.wav
		msgBox,housing applications!
		return
	}
	
	sleep 1000000
}

; --------------- key switches ---------------

!F2::
	Pause, Toggle
	return