class ClickModeCell extends Cell{
    private boolean selected;

    public ClickModeCell(color mode, int w, int index){
        super((width / 4) + (index * w) + (w * (index + 1)), w / 2, w, w, mode);
    }

    public void selectToggle(boolean selected){
        this.selected = selected;
    }

    public void show(int i){
        strokeWeight(3);
        if(this.selected){
            stroke(color(255, 0, 0));
        }else{
            stroke(0);
        }
        
        if(this.c == 0){
            fill(255);
        }else{
            fill(this.c);
        }
        rect(this.pos.x, this.pos.y, this.w, this.h);

        strokeWeight(1);
        if(this.c == 0){
            line(this.pos.x, this.pos.y, this.pos.x + this.w, this.pos.y + this.h);
            line(this.pos.x + this.w, this.pos.y, this.pos.x, this.pos.y + this.h);
        }
    }

    public color getColor(){
        return this.c;
    }
}