#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
; SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force

CoordMode,Pixel,Screen ;set coord mode for pixels to screen (not window)
CoordMode,Mouse,Screen ;set coord mode for mouse to screen


; --------------- User Variables ---------------



;menu colors
global ham := new Ingredient("ham",0xfdb8c7, new Point(112,0))
global peperoni := new Ingredient("peperoni",0xa20b06, new Point(0,-70))
global vegtables := new Ingredient("vegtables",0x15a440, new Point(0,-70))
 
global mouseColor := 0xf0f0f0


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
		return % "(" . this.x . ", " . this.y . ")"
	}
}

; --------------- Ingredient Class ---------------


class Ingredient{
	__New(name, menuColor, buttonOffset){
		this.name := name
		this.menuColor := menuColor
		this.buttonOffset := new Point(buttonOffset.X, buttonOffset.Y)
		return this
	}
	
	__Delete(){
		;msgBox, % "deleting: " . this.toString()
	}
	
	toString(){
		return % "Ingredient: " . this.name . "`n`tmenuColor: " . this.menuColor . "`n`tbutton offset: " . this.buttonOffset.toString()
	}
}

; --------------- functions ---------------

/**
 *  checks if the color was found on the screen
 *  @param checkColor - the color 
 *  @return - true if color was found
 */
colorCheck(checkColor){
	; foundX & foundY are  the variables that the coordinates of the found color will be stored in
	; 0 is the acceptable range of the color, we want it exact, so we choose 0
		
	;check for color1
	PixelSearch, foundX, foundY, 0,0 , A_ScreenWidth, A_ScreenHeight, checkColor, 0, RGB, Fast 
	
	if(ErrorLevel == 0){ ;color was not found
		return true
		
	}
	
	return false

}

getTopping(){
	
	if()
	PixelSearch, foundX, foundY, 0,0 , A_ScreenWidth, A_ScreenHeight, checkColor, 0, RGB, Fast 
}

mouseToPt(pt){
	mousemove, pt.X, pt.Y
}

; --------------- Main Code ---------------

Pause, Toggle ;start off

msgBox, % vegtables.toString()
while(true){

	
	
	sleep 1000
}

; --------------- key switches ---------------

!F2::
	Pause, Toggle
	return