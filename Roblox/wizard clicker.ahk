#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Pause on

MenuSpeed = 10
ShootSpeed = 500

Loop
{
Send,{f}
sleep MenuSpeed + 1
Send,{1}
sleep MenuSpeed + 2
Send,{1}
sleep MenuSpeed + 1
Click
sleep ShootSpeed + 1
Click
sleep ShootSpeed + 5
Click
sleep ShootSpeed + 2
Click
sleep ShootSpeed + 10
Click
sleep ShootSpeed + 1
}

!F2::Pause
return
