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
 
global TLBobBoxPt = new Point(344,785)
global BRBobBoxPt = new Point(1572,909)

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
checkIfGrey(inputColor){	

	blue:="0x" SubStr(inputColor,3,2) ;substr is to get the piece
	blue:=blue+0 ;add 0 is to convert it to the current number format

	green:="0x" SubStr(inputColor,5,2)
	green:=green+0

	red:="0x" SubStr(inputColor,7,2)
	red:=red+0
	
	;msgBox, % "" . red . ", " . green . ", " . blue
	if(blue=green && green=red){
		
		return true
	}
	return false
}

checkTime(){
	midtone = 0x808080
	PixelGetColor, sand, BRBobBoxPt.X, BRBobBoxPt.Y, RGB
	
	if(sand >= midtone){
		return true
	}else{
		return false
	}
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
checkForBobber(topLeft, bottomRight,foundPoint){
	static lastBobColor := darkestBobColor-GREY_INCREMENT ;
	static misses :=0
	
	leverage := 15 ;amount of variation allowed for the color
	step := 1 ;the amount of shades of grey to go through each loop
	
	;set the upper and lower bounds for finding color of the bobber
	checkingColor := lastBobColor-(leverage*GREY_INCREMENT)
	maxColor := lastBobColor+(leverage*GREY_INCREMENT)
	
	;if the last bob color is unreasonably low or high, we expand the color range to let us find it again
	;step is increased to speed up the proccess
	if(misses>=3 or lastBobColor<darkestBobColor or lastBobColor>lightestBobColor){
		
		;if daytime, start from lightest color and go to darkest
		if(checkTime){
			step :=-5
			checkingColor:=lightestBobColor
			maxColor:=darkestBobColor
		
		;if nighttime, start from darkest color and go to lightest
		}else{
			checkingColor:=darkestBobColor
			maxColor:=lightestBobColor
			step := 5
		}
		
	}
	
	;msgBox, start
	;loop through all the shades of grey in the range
	while(checkingColor<=maxColor){
	
		PixelSearch, foundX, foundY, topLeft.X,topLeft.Y , bottomRight.X, bottomRight.Y, checkingColor, 0, RGB, Fast 
		
		;if color was found, reset the last color, reset the found point, and return true
		if(ErrorLevel == 0 && checkingColor!=MOUSE_COLOR){ ;color was found
			foundPoint.set(foundX,foundY)
			
			PixelGetColor, newBobColor, foundX, foundY, RGB
			if(checkIfGrey(newBobColor)){
				lastBobColor=newBobColor
			}
			
			misses := 0
			return true
		}
		
		;go to the next shade of grey
		checkingColor+=GREY_INCREMENT*step
	}
	
	misses+=1
	;msgBox, end
	return false
}

tohex(num)
{
  VarSetCapacity(buf, 40)
  ;Change the %X to lowercase if you want the hex output in lowercase (ex: ff instead of FF)
  if num is integer
     DllCall("wsprintf", "str", buf, "str", "%X", "int64", num)
  if num is float
     DllCall("wsprintf", "str", buf, "str", "%X", "float", num)
  return buf
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

cast()
while(true){
	
	; mousemove, CAST_BTN_LOC.X, CAST_BTN_LOC.Y
	;Click
	
	if(checkForBobber(TLBobBoxPt,BRBobBoxPt,bobPt)){
		cast()
		sleep 2500
		cast()
		;mouseToPt(bobPt)
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
	
	
#A::
	keywait, LButton, D
	KeyWait, LButton, U
	MouseGetPos, mouseX, mouseY
	CAST_BTN_LOC.set(mouseX,mouseY)
	
	msgBox, % "button: " . CAST_BTN_LOC.toString()
	return