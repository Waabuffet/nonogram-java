abstract class Cell{
    protected PVector pos;
    protected color c;
    int w, h;

    protected Cell(float x, float y, int w, int h, color c){
        this.pos = new PVector(x, y);
        this.w = w;
        this.h = h;
        this.c = c;
    }

    public boolean mousePressed(float x, float y){
        if(x > this.pos.x && y > this.pos.y && x < this.pos.x + this.w && y < this.pos.y + this.h){
            return true;
        }
        return false;
    }
}