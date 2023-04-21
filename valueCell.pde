class ValueCell extends Cell{
    private color[] textColors;
    private String[] values;
    private int nextString = 0;
    private boolean isTop;

    public ValueCell(int x, int y, int w, int h, int tiles_count, boolean isTop){
        super(x, y, w, h, color(220, 220, 220));
        this.values = new String[tiles_count];
        this.textColors = new color[tiles_count];
        this.isTop = isTop;
    }

    public void show(int startX, int startY){
        stroke(0);
        strokeWeight(1);
        fill(this.c);
        float posX = (this.pos.x * this.w) + startX;
        float posY = (this.pos.y * this.h) + startY;
        rect(posX, posY, this.w, this.h);

        if(this.nextString > 0){
            for(int i = 0; i < this.nextString; i++){
                float indentX = (!this.isTop)? 0.5 : float(i + 1)/(this.nextString + 1);
                float indentY = (this.isTop)? 0.5 : float(i + 1)/(this.nextString + 1);
                fill(this.textColors[i]);
                textAlign(CENTER);
                if(this.isTop){
                    textSize(this.w / 4);
                }else{
                    textSize(this.w / 2);
                }
                text(this.values[i], posX + (this.w * indentX), posY + (this.h * indentY));
            }
        }
    }

    public void addValue(String value, color c){
        this.values[this.nextString] = value;
        this.textColors[this.nextString] = c;
        this.nextString++;
    }
}