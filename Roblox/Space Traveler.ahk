#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.




CoordMode,Pixel,Screen ;set coord mode for pixels to screen (not window)
CoordMode,Mouse,Screen ;set coord mode for mouse to screen

global routeColor1 := 0xa8a83d ;unhighlighted color
global routeColor2 := 0xffff4d ;highlighted color


global menuIdentifingColor = 0x260d0d ;the close button on the menu
global pvpMenuColor = 0x295e29 ;the confirm button on the pvp warning menu
global planetTitleColor = 0x505050 ;the confirm button on the pvp warning menu
global highlightedCancelButton = 0x5a3232 ;the confirm button on the pvp warning menu

/**
 *  safley exits the game
 */
exitSequence(){
	send {i}
	mousemove, 20, 20, 5
	sleep 100
	
	;click on the door icon
	mousemove, 560, 635, 5
	click
	
	sleep 100
	
	;click "logout safley"
	mousemove, 970, 680, 5
	click
	
	sleep 100
	
	WinClose, Roblox Player
	return
}
/*
*/

/**
 *  makes sure that pressing spacebar to open the menu works
 *  @return - true if it works
 */
testMenu(){

}


/**
 *  halts the program until warping is avalible again
 */
 
 
waitForNextStarSystem(){
	
	;wait for loading screen to start
	
	
	sleep 20000
	
	;wait for warp menu to be avalible
	i := 0
	while(i<100){
		Send {Space Down}
		sleep 1000
		if(colorCheck(menuIdentifingColor) == true){
			;loading screen is up
			Send {Space Up}
			sleep 20
			return
		}
		Send {Space Up}
		sleep 2000 
	}
	
	WinClose, Roblox Player
	exit, 5
}

/**
 *  attempts to warp a specific number of times and will let the user know if all the warps failed
 *  @param attempts - the amount of times to attempt warping + 1
 *  @return - true if warping was successful
 *  		- false if warping was not successful 
 */
securityWarp(attempts){
	
	;try with no gitter
	if(warp(0,0 ) = true){
		return true
	}
	
	loop, %attempts% {
		Send {Space Down}
		sleep 500
		Random, randGitter, -5, -1
		Random, randStep, 0.0, 1.0
		if(warp(randGitter,randStep ) = true){
			return true
		}
	}
	
	loop, %attempts% {
		Send {Space Down}
		sleep 500
		Random, randGitter, -10, -1
		Random, randStep, 0.0, 1.0
		if(warp(randGitter,randStep ) = true){
			return true
		}
	}
	
	return false
}

/**
 *  warps the ship to the next star system (NOTE: warping may fail)
 *  @return - true for successful warp
 */
warp(gitter, step){
	
	i := gitter
	while(i<20){
		
		;moves mouse
		mousemove, 0, i , 25, R 
		if(colorCheck(routeColor2) == true){
			Send {Space Up} ;warp to planet
			closePVPCheck()
			return true
		}
		
		if(colorCheck(highlightedCancelButton) == true){
			return false
		}
		
		sleep 20
		i+=1
	}
	
	;warping failed
	closeWarpMenu()
	return false

}


/**
 *  closes the warp menu
 */
closeWarpMenu(){
	mousemove, 0, 100 , 10, R 
	Send {Space Up}
}

/**
 *  clicks the button to prompt the ship to continue into the pvp area
 */
closePVPCheck(){ 
	mousemove, 100, 10 , 10
	mousemove, 800, 670 , 25 
	
	Click
	
	return
}	


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


/**
 *  UNUSED FUNCTION
 *  gets the relative position of a coordinate in respect to another coordinate
 */
relativePos(pivotX, pivotY, posX, posY, byref retX, byref retY){
	retX := posX- pivotX 
	retY := posY - pivotY
	
	return
}


F1::pause, toggle

!F2::

	while(true){
		Send {Space Down}
		Sleep 1000
		if (colorCheck(routeColor1) == false){
			;exitSequence()
			msgbox, finished
			return
		}

		if (securityWarp(7) = false){
			;reattempting the warp failed enough times that we've been in the system
			;long enough and it isn't safe
			exitSequence()
			return
		}
	
		
		waitForNextStarSystem()
		
	}


	
	return
	

	
