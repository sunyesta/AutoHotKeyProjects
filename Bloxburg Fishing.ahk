#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
; SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force

CoordMode,Pixel,Screen ;set coord mode for pixels to screen (not window)
CoordMode,Mouse,Screen ;set coord mode for mouse to screen


; --------------- User Variables ---------------

global ZERO_PT = new Point(0,0)
global END_OF_SCREEN_PT = new Point(A_ScreenWidth, A_ScreenHeight)

global GREY_INCREMENT := 0x010101

global CAST_BTN_LOC = new Point(960, 1080)
 
global TLBobBoxPt = new Point(420,660)
global BRBobBoxPt = new Point(1650,940)

global darkestBobColor = 0x3e3e3e
global lightestBobColor = 0xc2c2c2

global MOUSE_COLOR := 0xf0f0f0


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
	
	set(x,y){
		this.X := x
		this.Y := y
	}
	
	toString(){
		return % "(" . this.x . ", " . this.y . ")"
	}
	
	print(){
		msgBox, % this.toString()
	}
}

; --------------- functions ---------------




/**
 *  Checks if a pixel is grey at a given point
 *  
 *  @param point - the pixel coordinate that is being checked
 *  
 *  @return - true if the screen is grey color at that pixel
 */
pixelCheckGrey(point){
	PixelGetColor, colorAtPixel, xPixel, yPixel, RGB
	
	
	blue:="0x" SubStr(colorAtPixel,3,2) ;substr is to get the piece
	blue:=blue+0 ;add 0 is to convert it to the current number format

	green:="0x" SubStr(colorAtPixel,5,2)
	green:=green+0

	red:="0x" SubStr(colorAtPixel,7,2)
	red:=red+0
	
	msgBox, % "" . red . ", " . green . ", " . blue
	if(blue=green && green=red && colorAtPixel!=MOUSE_COLOR){
		
		return true
	}
	return false
}

/**
 *  checks if a pixel is grey in a given box on the screen
 *  
 *  @param step - the space between each checked pixel
 *  @param xMin - the top-left x-pixel of the box
 *  @param yMin - the top-left y-pixel of the box
 *  @param xMax - the bottom-right x-pixel of the box
 *  @param yMax - the bottom-right y-pixel of the box
 *  
 *  @return - true if there is a grey pixel in the box
 */
boxCheckGrey(topLeft, bottomRight,foundPoint){
	static currentGrey = darkestBobColor
	step := 5
	increment := GREY_INCREMENT*step
	
	checkingColor := darkestBobColor
	
	while(checkingColor<=lightestBobColor){
		;msgBox, checking color %checkingColor%
		
		PixelSearch, foundX, foundY, topLeft.X,topLeft.Y , bottomRight.X, bottomRight.Y, checkingColor, step, RGB, Fast 
		
		if(ErrorLevel == 0 && checkingColor!=MOUSE_COLOR){ ;color was found
			;msgBox, found %foundX% %foundY%
			foundPoint.set(foundX,foundY)
			return true
		}
		
		checkingColor+=increment
	}
	;msgBox,end
	return false
}

checkForBobber(byref foundPoint){
	if(boxCheckGrey(TLBobBoxPt,BRBobBoxPt,foundPoint)){
		;msgBox, found it!
		return true
	}
	
	return false
}

mouseToPt(pt){
	mousemove, pt.X, pt.Y
	return
}

cast(){
	mouseToPt(CAST_BTN_LOC)
	Click
	return
}

; --------------- Main Code ---------------
Pause, Toggle ;start off
bobPt := new Point(0,0)

;cast()
while(true){
	
	; mousemove, CAST_BTN_LOC.X, CAST_BTN_LOC.Y
	;Click
	
	if(checkForBobber(bobPt)){
		;mouseToPt(bobPt)
		cast()
		sleep 2500
		cast()
	}
	
	
	sleep 500
}

; --------------- key switches ---------------

!F2::
	Pause, Toggle
	return
	
#S::

	keywait, LButton, D
	MouseGetPos, mouseX, mouseY
	TLBobBoxPt.set(mouseX,mouseY)
	
	KeyWait, LButton, U
	
	keywait, LButton, D
	MouseGetPos, mouseX, mouseY
	BRBobBoxPt.set(mouseX,mouseY)
	
	msgBox, % "box: " . TLBobBoxPt.toString() . " - " . BRBobBoxPt.toString()
	return