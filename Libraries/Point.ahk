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