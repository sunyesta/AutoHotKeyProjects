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

global ROWS := 5
global COLS := 10
global CELLS := 49

global NULL = 0

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

class Cell{
	__New(x,y, i){
		this.X := x
		this.Y := y
		this.Index := i
		this.LastUsed := 0
		return this
	}
	toString(){
		return % "(" . this.x . ", " . this.y . ")"
	}
	
	print(){
		msgBox, % this.toString()
	}
}

; --------------- plr control functions ---------------

stepRight(){
	rightPt := getPtFromPlrOffset(1.1,.5,ON_FOOT_MID_OF_BLOCK)
	MouseMove, rightPt.X, rightPt.Y
	Sleep, 10
	send, {e Down}
	Sleep, 10
	send, {e Up}
	Sleep, 500
	Send, {Space down}
	sleep 10
	Send, {Space up}
	sleep 10
}

; --------------- functions ---------------

myMouseClick(x,y){
	static MOUSE_WAIT_TIME = 30
	MouseMove, x, y
	sleep MOUSE_WAIT_TIME
	Send, {LButton down}
	sleep MOUSE_WAIT_TIME
	Send, {LButton up}
	sleep MOUSE_WAIT_TIME

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

getHotbarHotKey(index){
	index += 1
	index := Mod(index, COLS+1)
	if(index = 10){
		index := 0
	}

	if(index > 10){
		msgBox, % "index too large: " . index
		ExitApp
	}

	return index
}

getLRUColor(byref cellHolding, byref hotbar){
	;msgBox, % "hotbar: " . obj2str(hotbar)
	LRUColor := hotbar[0]

	i := 1
	while(i<COLS){
		if(cellHolding[hotbar[i]].LastUsed < cellHolding[LRUColor].LastUsed){
			LRUColor := hotbar[i]
		}
		i+=1
	}

	return LRUColor
}

swapCells(cellColor1, cellColor2, byref cellHolding){
	;swap cells physically
	
	;msgBox, clicking
	;msgBox, % "1: " . obj2str(cellHolding[cellColor1]) . " 2: " .  obj2str(cellHolding[cellColor2])
	myMouseClick(cellHolding[cellColor1].X, cellHolding[cellColor1].Y) 
	myMouseClick(cellHolding[cellColor2].X, cellHolding[cellColor2].Y) 
	myMouseClick(cellHolding[cellColor1].X, cellHolding[cellColor1].Y) 

	;swap cells in the code
	;msgBox, % "bfr 1: " . obj2str(cellHolding[cellColor1]) . " 2: " .  obj2str(cellHolding[cellColor2])
	temp := cellHolding[cellColor2]
	cellHolding[cellColor2] := cellHolding[cellColor1]
	cellHolding[cellColor1] := temp
	;msgBox, % "after 1: " . obj2str(cellHolding[cellColor1]) . " 2: " .  obj2str(cellHolding[cellColor2])
}

grabItem(blockColor, byref cellHolding, byref hotbar){
	static tick = 0
	tick += 1
	
	;msgBox, % CELLS
	if(cellHolding[blockColor].Index >= COLS){
		;put item into hotbar
		;msgBox, "swapping"
		LRUColor := getLRUColor(cellHolding, hotbar)
		;msgBox, % "lrucolor = " . LRUColor
		;msgBox, % "bfr cur: " . obj2str(cellHolding[blockColor]) . " lru: " .  obj2str(cellHolding[LRUColor])
		swapCells(blockColor, LRUColor, cellHolding)
		;msgBox, % "back cur: " . obj2str(cellHolding[blockColor]) . " lru: " .  obj2str(cellHolding[LRUColor])
		hotbar[cellHolding[blockColor].Index] := blockColor
	}
	;msgBox, % "hotbar = " . obj2str(hotbar)
	

	;grab the item now that it is in the hotbar
	cellHolding[blockColor].LastUsed := tick
	hotkey := getHotbarHotKey(cellHolding[blockColor].Index)
	;msgBox, % "index = " . cell.Index
	;msgBox, % "hotkey = " . hotkey
	send, {%hotkey% Down}
	sleep, 30
	send, {%hotkey% Up}
	sleep, 30
	
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

makeCellFromInventoryIndex(byref hotbar, curColor){
	static i = -1
	i+=1
	startPt := new Point(50, 50)
	step := 58

	r := Floor(i / COLS)
	c := Mod(i,COLS)

	x := startPt.X + (c * step)
	y := startPt.Y + (r * step)
	;msgBox, % "pt" . new Point(x,y).toString()

	if(i<COLS){
		hotbar[i] := curColor
	}

	
	return new Cell(x, y, i)
}



getColorTable(pixelArtImg, byref hotbar){
	inventoryImg := Gdip_CreateBitmapFromFile("inventoryTemplate.png")
	pGraphics := Gdip_GraphicsFromImage(inventoryImg)
	
	inventoryPointTable := {}
	inventoryPointTable[ROPE] := makeCellFromInventoryIndex(hotbar, ROPE)
	inventoryPointTable[PICKAXE] := makeCellFromInventoryIndex(hotbar, PICKAXE)


	height := Gdip_GetImageHeight(pixelArtImg)
	width := Gdip_GetImageWidth(pixelArtImg)

	
	;itterate through all the pixels in the image
	x:=0
	while(x<width){
		y:=0
		while(y<height){
			curColor := Gdip_GetPixel( pixelArtImg, x, y)
			
			;if a color isn't in the inventoryPointTable table, insert it and add it to the inventoryImg
			if(!inventoryPointTable.HasKey(curColor)){
				
				inventoryPointTable[curColor] := makeCellFromInventoryIndex(hotbar, curColor)
				
				

				pBrush := Gdip_BrushCreateSolid(curColor)
				Gdip_FillRectangle(pGraphics, pBrush, inventoryPointTable[curColor].X, inventoryPointTable[curColor].Y, 20, 20)
				

				
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
    pixelArtImg := Gdip_CreateBitmapFromFile("man_good.png")
    
	height := Gdip_GetImageHeight(pixelArtImg)
	width := Gdip_GetImageWidth(pixelArtImg)

	hotbar := {} ;array filled with colors
    inventoryPtTable := getColorTable(pixelArtImg, hotbar)
	;msgbox, % Obj2Str(hotbar)
	

    ;itterate through all the pixels in the image from bottom(+y) left(-x) to top(-y) right(+x) 1 col(x) at a time
	x=0
	while(x<width){
		
		;build rope of 4 to the right
		grabItem(ROPE, inventoryPtTable, hotbar)
		clickAtOffsetFromPlr(1,0, ON_FOOT_MID_OF_BLOCK) 
		clickAtOffsetFromPlr(1,-1, ON_FOOT_MID_OF_BLOCK) 
		clickAtOffsetFromPlr(1,-2, ON_FOOT_MID_OF_BLOCK) 
		clickAtOffsetFromPlr(1,-3, ON_FOOT_MID_OF_BLOCK)

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
			grabItem(curColor, inventoryPtTable, hotbar)
			clickAtOffsetFromPlr(-1,0, ON_TOP_OF_MID_ROPE) 

			;break rope below plr
			grabItem(PICKAXE, inventoryPtTable, hotbar)
			clickAtOffsetFromPlr(0,0, ON_TOP_OF_MID_ROPE) 

			;place rope above plr
			grabItem(ROPE, inventoryPtTable, hotbar)
			clickAtOffsetFromPlr(0,-4, ON_TOP_OF_MID_ROPE) 

			y-=1
		}

		;break ropes to get off
		grabItem(PICKAXE, inventoryPtTable, hotbar) ;grab pickaxe
		clickAtOffsetFromPlr(0,0, ON_TOP_OF_MID_ROPE) 
		clickAtOffsetFromPlr(0,-1, ON_TOP_OF_MID_ROPE) 
		clickAtOffsetFromPlr(0,-2, ON_TOP_OF_MID_ROPE) 
		clickAtOffsetFromPlr(0,-3, ON_SINGLE_ROPE_KNOT) 

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
	;stepRight()
	
	build()
    
    msgBox, done
    
	return
	
	


#i::
	InputBox, HORIZONTAL_STEP_TIME, "horizontal step time"
	return

!F2::
	ExitApp
	return
	