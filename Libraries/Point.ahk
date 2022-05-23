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

    setPtToMouse(){
        MouseGetPos, mouseX, mouseY
	    this.set(mouseX,mouseY)
    }
}

pointClick(point){
	static MOUSE_WAIT_TIME = 30
	MouseMove, point.X, point.Y
	sleep MOUSE_WAIT_TIME
	Send, {LButton down}
	sleep MOUSE_WAIT_TIME
	Send, {LButton up}
	sleep MOUSE_WAIT_TIME

}