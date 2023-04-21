class ImageCell extends Cell{
    private PVector index;
    private boolean marked, clicked;
    private int w;
    private color designatedColor;

    public ImageCell(int x, int y, int w, int start, color designatedColor){
        super((x * w) + start, (y * w) + start, w, w, color(255, 255, 255));
        this.index = new PVector(x, y);
        this.w = w;
        this.designatedColor = designatedColor;
    }

    public void show(){
        stroke(0);
        strokeWeight(1);
        if(this.clicked && !this.marked){
            fill(this.designatedColor);
        }else{
            fill(this.c);
        }
        rect(this.pos.x, this.pos.y, this.w, this.h);
        if(this.marked){
            this.showMark();
        }
    }

    private void showMark(){
        stroke(0);
        strokeWeight(1);
        line(this.pos.x, this.pos.y, this.pos.x + this.w, this.pos.y + this.h);
        line(this.pos.x + this.w, this.pos.y, this.pos.x, this.pos.y + this.h);
    }

    public boolean showColor(color sentColor){
        this.clicked = true;
        if(this.designatedColor == 0){
            this.marked = true;
        }
        if(this.designatedColor == sentColor){
            return true;
        }
        return false;
    }

    public boolean isClicked(){
        return this.clicked;
    }

    public void mark(){
        this.marked = true;
        this.clicked = true;
    }
}