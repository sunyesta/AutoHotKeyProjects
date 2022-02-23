#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
; SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force

CoordMode,Pixel,Screen ;set coord mode for pixels to screen (not window)
CoordMode,Mouse,Screen ;set coord mode for mouse to screen


; --------------- User Variables ---------------

global UserCodePtTL = new Point(1019,335)
global UserCodePtBR = new Point(1135,360)

global colTops = 430
global colBots = 850

global col1X = 723
global col2X = 915
global col3X = 1105
global col4X = 1300

global colWidth = 30

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

getColorNOTBLACK(boxTLPT, boxBRPT){
	;msgBox,  ya
	WHITE := 0xFFFFFF
	PixelSearch, foundX, foundY, boxTLPT.X,boxTLPT.Y , boxBRPT.X, boxBRPT.Y, WHITE, 254, RGB, Fast 
	PixelGetColor, foundColor, foundX, foundY, RGB
	
	return foundColor
}


/**
 *  checks if the color was found on the screen
 *  @param checkColor - the color 
 *  @return - true if color was found
 */
colorCheck(checkColor, TLpt, BRpt){
	; foundX & foundY are  the variables that the coordinates of the found color will be stored in
	; 0 is the acceptable range of the color, we want it exact, so we choose 0
		
	;check for color1
	PixelSearch, foundX, foundY, TLpt.X ,TLpt.Y , BRpt.X , BRpt.Y , checkColor, 0, RGB, Fast 
	
	if(ErrorLevel == 0){ ;color was not found
		return true
		
	}
	
	return false

}

; --------------- Main Code ---------------
Pause, Toggle ;start off


global col1TR = new Point(col1X,colTops)
global col1BR = new Point(col1X+colWidth,colBots)

global col2TR = new Point(col2X,colTops)
global col2BR = new Point(col2X+colWidth,colBots)

global col3TR = new Point(col3X,colTops)
global col3BR = new Point(col3X+colWidth,colBots)

global col4TR = new Point(col4X,colTops)
global col4BR = new Point(col4X+colWidth,colBots)


while(true){
	;msgBox, yes
	sleep 1000
	checkingColor := getColorNOTBLACK(UserCodePtTL,UserCodePtBR)
	;msgBox, %checkingColor%
	
	found := false
	while(found == false){
		found := colorCheck(checkingColor, col1TR, col1BR) or colorCheck(checkingColor, col2TR, col2BR) or colorCheck(checkingColor, col3TR, col3BR) or colorCheck(checkingColor, col4TR, col4BR)
		sleep 50
	}
	;msgBox, found = %found%
	Click
	sleep 500
}

return

; --------------- key switches ---------------

!F2::
	Pause, Toggle
	return
	

