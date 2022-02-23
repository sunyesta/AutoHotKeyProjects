for(int c=0; c< imgWidth; c++){ //start at left
    build rope of 4 to the right
    step right so we are at base 
    travel to top of rope
    for (int r=imgHeight-1; r< imgHeight; r++){ //start at bottom
        grabBlock(inventory[color at pixel r,c]) //blocks are stored in a map: key = color, val = inventory index
        placeBlockAtFeet
        move up by 1
    }
    delete rope
    move to the left
}




for(int c=0; c< imgWidth; c++){ //start at left
    build rope of 4 to the right
    step right so we are at base 
    
    hold up to stay on top of rope
    move to right
    
    for (int r=imgHeight-1; r>=0; r--){ //start at bottom
        grabBlock(inventory[color at pixel r,c]) //blocks are stored in a map: key = color, val = inventory index
        place block at 1 below and to the left of the plr
        break rope below
        place a rope above
    }
    
    break 4 ropes that you are on
    stop holding up
}
