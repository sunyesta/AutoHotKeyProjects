#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

noMoreTabsColor := 0xc0c0c0 ;sai background
firstTabX := 355
firstTabY := 1040

!F2::
	while(true){
		PixelGetColor, foundColor, firstTabX, firstTabY, rgb
		if(ErrorLevel != 0){ ;color was not found
			msgbox, err
			return	
		}
		
		if(foundColor = noMoreTabsColor){
			msgbox, done
			return
		}
		sleep 20
		
		mousemove, firstTabX, firstTabY, 5
		click
		sleep 20
		
		send, {Enter}
		sleep 20
		send, {Enter}
		sleep 30000
	
	}
	
	

