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

;inventory stuff
global ROPE := 0
global PICKAXE := 1
global CELLS := 49

;plr direction
global LEFT := 0
global RIGHT := 1

;mobility types
global ON_TOP_OF_MID_ROPE := 0
global ON_TOP_OF_MID_ROPE_INIT := 1
global ON_FOOT_MID_OF_BLOCK := 2
global ON_SINGLE_ROPE_KNOT := 3

;sleep times
global HORIZONTAL_STEP_TIME := 230
global MIN_SLEEP := 100

; --------------- plr control functions ---------------

stepRight(){
	send, {d Down}
	Sleep, HORIZONTAL_STEP_TIME
	send, {d Up}
	Sleep, HORIZONTAL_STEP_TIME
}

; --------------- functions ---------------

myMouseClick(x,y){
	MouseMove, x, y
	Send, {LButton down}
	sleep 10
	Send, {LButton up}
	sleep 10

}

;https://www.autohotkey.com/boards/viewtopic.php?t=43022
x_to_y_step_k(byref i, x, y, k:=1){
	return ( i := x+(a_index-1) ) <= y ? ( a_index += k-1, true ) : ( i -= k, false )
}

ConvertARGB(ARGB, Convert := 0)
{
    SetFormat, IntegerFast, Hex
    RGB += ARGB
    RGB := RGB & 0x00FFFFFF
    if (Convert)
        RGB := (RGB & 0xFF000000) | ((RGB & 0xFF0000) >> 16) | (RGB & 0x00FF00) | ((RGB & 0x0000FF) << 16)
    return RGB
}


toggleItem(inventoryPointTable, blockColor){
	static checkColorPt := new Point(29, 29)
	static correctColor := 0xffe61e

	myMouseClick(inventoryPointTable[blockColor].X, inventoryPointTable[blockColor].Y)
	
}

global plrFeetPtNorm := new Point(960, 613)
global plrFeetPtRope := new Point(960, 621)
global plrFeetPtRopeInit := new Point(960, 620)
global plrFeetPtRopeSingle := plrFeetPtNorm

getPtFromPlrOffset(xOffset, yOffset, mobilityType){
	plrFeetPt := new Point(0,0)
	if(mobilityType = ON_FOOT_MID_OF_BLOCK){
		plrFeetPt := plrFeetPtNorm
	}else if(mobilityType = ON_TOP_OF_MID_ROPE){
		plrFeetPt := plrFeetPtRope
	}else if(mobilityType = ON_SINGLE_ROPE_KNOT){
		plrFeetPt := plrFeetPtRopeSingle
	}else{
		msgBox, unknown mobilityType
		ExitApp
	}
	
	blockSize := 16

	return new Point(plrFeetPt.X + (xOffset * blockSize), plrFeetPt.Y + (yOffset * blockSize))
}

clickAtOffsetFromPlr(xOffset, yOffset, mobilityType){
	offsetPt := getPtFromPlrOffset(xOffset, yOffset, mobilityType)

	myMouseClick(offsetPt.X, offsetPt.Y)
	Sleep, MIN_SLEEP
}

getPixelFromInventoryIndex(i){
	startPt := new Point(50, 50)
	step := 58
	
	rows := 5
	cols := 10
	
	r := Floor(i / cols)
	c := Mod(i,cols)

	x := startPt.X + (c * step)
	y := startPt.Y + (r * step)
	;msgBox, % "pt" . new Point(x,y).toString()
	return new Point(x, y)
}

getColorTable(pixelArtImg){
	inventoryImg := Gdip_CreateBitmapFromFile("inventoryTemplate.png")
	pGraphics := Gdip_GraphicsFromImage(inventoryImg)
	
	inventoryPointTable := {}
	inventoryPointTable[ROPE] := getPixelFromInventoryIndex(0)
	inventoryPointTable[PICKAXE] := getPixelFromInventoryIndex(1)

	height := Gdip_GetImageHeight(pixelArtImg)
	width := Gdip_GetImageWidth(pixelArtImg)

	colorCount = 2
	
	;itterate through all the pixels in the image
	x:=0
	while(x<width){
		y:=0
		while(y<height){
			curColor := Gdip_GetPixel( pixelArtImg, x, y)
			
			;if a color isn't in the inventoryPointTable table, insert it and add it to the inventoryImg
			if(!inventoryPointTable.HasKey(curColor)){
				
				inventoryPointTable[curColor] := getPixelFromInventoryIndex(colorCount)
				
				pBrush := Gdip_BrushCreateSolid(curColor)
				Gdip_FillRectangle(pGraphics, pBrush, inventoryPointTable[curColor].X, inventoryPointTable[curColor].Y, 20, 20)
				
				colorCount+=1

				
			}
			y+=1
		}
		x+=1
		
	}

	
	if(colorCount > CELLS){
		msgBox % "too many colors: " . colorCount . " ------- need at most: " . CELLS
	}

	Gdip_SaveBitmapToFile(inventoryImg, "FinalImage.png")
	msgBox, fill colors now
	return inventoryPointTable
}

build(){
	;setup image for processing
    pToken := Gdip_Startup()
    pixelArtImg := Gdip_CreateBitmapFromFile("fox.png")
    
	height := Gdip_GetImageHeight(pixelArtImg)
	width := Gdip_GetImageWidth(pixelArtImg)

    inventoryPtTable := getColorTable(pixelArtImg)
	
    ;itterate through all the pixels in the image from bottom(+y) left(-x) to top(-y) right(+x) 1 col(x) at a time
	x=0
	while(x<width){
		
		;build rope of 4 to the right
		toggleItem(inventoryPtTable, ROPE) ;grab rope
		clickAtOffsetFromPlr(1,0, ON_FOOT_MID_OF_BLOCK) 
		clickAtOffsetFromPlr(1,-1, ON_FOOT_MID_OF_BLOCK) 
		clickAtOffsetFromPlr(1,-2, ON_FOOT_MID_OF_BLOCK) 
		clickAtOffsetFromPlr(1,-3, ON_FOOT_MID_OF_BLOCK)
		toggleItem(inventoryPtTable, ROPE) ;return rope

		stepRight() ;go to right of the rope
		
		;get on rope
		send, {w Down} ;hold up to stay on top of rope
		sleep 100
		send, {w Up} ;hold up to stay on top of rope
		sleep 100
		send, {w Down} ;hold up to stay on top of rope
		sleep 100
		send, {w Down} ;hold up to stay on top of rope
		sleep 100

		y:=height-1
		while(y>=0){
			curColor := Gdip_GetPixel( pixelArtImg, x, y)
			
			;place block below and to the left of the plr's feet
			toggleItem(inventoryPtTable, curColor)
			clickAtOffsetFromPlr(-1,0, ON_TOP_OF_MID_ROPE) 
			toggleItem(inventoryPtTable, curColor)

			;break rope below plr
			toggleItem(inventoryPtTable, PICKAXE)
			clickAtOffsetFromPlr(0,0, ON_TOP_OF_MID_ROPE) 
			toggleItem(inventoryPtTable, PICKAXE)

			;place rope above plr
			toggleItem(inventoryPtTable, ROPE)
			clickAtOffsetFromPlr(0,-4, ON_TOP_OF_MID_ROPE) 
			toggleItem(inventoryPtTable, ROPE)

			y-=1
		}

		;break ropes to get off
		toggleItem(inventoryPtTable, PICKAXE) ;grab pickaxe
		clickAtOffsetFromPlr(0,0, ON_TOP_OF_MID_ROPE) 
		clickAtOffsetFromPlr(0,-1, ON_TOP_OF_MID_ROPE) 
		clickAtOffsetFromPlr(0,-2, ON_TOP_OF_MID_ROPE) 
		clickAtOffsetFromPlr(0,-3, ON_SINGLE_ROPE_KNOT) 
		toggleItem(inventoryPtTable, PICKAXE) ;return pickaxe

		sleep, 3000
		send, {w Up} ;stop holding up
		

		x+=1
	}

	
    Gdip_DisposeImage(pixelArtImg)
    Gdip_Shutdown(pToken)

	;msgBox, % "done"
    
}

; --------------- key switches ---------------

;#S
#S::
    ;send, {w Down}
	;sleep, 10000
	;msgBox, % "ready"
	;stepLeft()
	
	build()
    
    msgBox, done
    
	return
	
	


#i::
	InputBox, HORIZONTAL_STEP_TIME, "horizontal step time"
	return

!F2::
	ExitApp
	return
	