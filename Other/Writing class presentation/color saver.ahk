#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force

#S::

    i:=0
    while(i<100){
    send, {CtrlDown}{AltDown}{c Down}
    MouseClick
    sleep, 100
    send {CtrlUp}{AltUp}{c Up}
    
    FileAppend,  %clipboard%`n, ./dump.txt
    i+=1
    }
    return

!F2::
	ExitApp
	return
	