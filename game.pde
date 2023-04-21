int lives = 3;
Difficulty difficulty = Difficulty.EXTREME;
// int[][] image = new int[][] {
//     {0, 1, 0, 1, 0},
//     {0, 1, 0, 1, 0},
//     {1, 1, 1, 1, 1},
//     {0, 1, 0, 1, 0},
//     {0, 1, 0, 1, 0},
// };

int[][] image;// = new int[][] {
//     {1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
//     {0, 1, 0, 0, 0, 0, 0, 0, 1, 0},
//     {0, 0, 1, 0, 0, 0, 0, 1, 0, 0},
//     {0, 0, 0, 1, 0, 0, 1, 0, 0, 0},
//     {0, 0, 0, 0, 2, 2, 0, 0, 0, 0},
//     {0, 0, 0, 0, 2, 2, 0, 0, 0, 0},
//     {0, 0, 0, 1, 0, 0, 1, 0, 0, 0},
//     {0, 0, 1, 0, 0, 0, 0, 1, 0, 0},
//     {0, 1, 0, 0, 0, 0, 0, 0, 1, 0},
//     {1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
// };

// ==============================================================================
int lives_remaining, lives_height = 100;
int scene_height = 1700,
    scene_width = scene_height - lives_height,
    tiles_count = DifficultyManager.getInstance(difficulty).getTilesCount(),
    tile_width = scene_width / (tiles_count + 2),
    clickModeWidth = lives_height / 2;

ArrayList<ClickModeCell> clickModeCells;
ImageCell[][] imageCells;
ValueCell[] valueCellsX;
ValueCell[] valueCellsY;
color selectedColor = 0;

void settings(){
    size(scene_width, scene_height);
}

void setup(){
    readImage();
    configureImage();
    configureClickModeCells();
    newGame();
}

void readImage(){
    image = new int[tiles_count][tiles_count];
    String[] lines = loadStrings("result.txt");
    for (int i = 0 ; i < lines.length; i++) {
        String[] bin = lines[i].split(" ");
        for (int j = 0 ; j < bin.length; j++) {
            image[i][j] = Integer.valueOf(bin[j]);
        }
    }
    for (int i = 0 ; i < image.length; i++) {
        String line = "";
        for (int j = 0 ; j < image[i].length; j++) {
            line += image[i][j] + " ";
        }
        println(line);
    }

}

void configureImage(){
    for(int y = 0; y < tiles_count; y++){
        for(int x = 0; x < tiles_count; x++){
            if(image[y][x] == 1){
                image[y][x] = color(0,0,0);
            }
            else if(image[y][x] == 2){
                image[y][x] = color(255,0,0);
            }
        }
    }
}

void configureClickModeCells(){
    ArrayList<Integer> availableColors = new ArrayList<Integer>();
    availableColors.add(0);
    for(int y = 0; y < tiles_count; y++){
        for(int x = 0; x < tiles_count; x++){
            if(!colorAdded(availableColors, image[y][x])){
                availableColors.add(image[y][x]);
            }
        }
    }

    clickModeCells = new ArrayList<ClickModeCell>();
    for(int i = 0; i < availableColors.size(); i++){
        clickModeCells.add(new ClickModeCell(availableColors.get(i), clickModeWidth, i));
    }
    clickModeCells.get(0).selectToggle(true);
    println(clickModeCells.size());
}

boolean colorAdded(ArrayList<Integer> availableColors, color c){
    for(int i = 0; i < availableColors.size(); i++){
        if(availableColors.get(i) == c){
            return true;
        }
    }
    return false;
}

void newGame(){
    lives_remaining = lives;
    imageCells = new ImageCell[tiles_count][tiles_count];
    valueCellsX = new ValueCell[tiles_count];
    valueCellsY = new ValueCell[tiles_count];
    for(int y = 0; y < tiles_count; y++){
        for(int x = 0; x < tiles_count; x++){
            imageCells[y][x] = new ImageCell(x, y, tile_width, tile_width * 2, image[y][x]);
        }
        valueCellsX[y] = new ValueCell(0, y, tile_width * 2, tile_width, tiles_count, true);
        valueCellsY[y] = new ValueCell(y, 0, tile_width, tile_width * 2, tiles_count, false);
    }
    addValues();
}

void draw(){
    background(255);
    noStroke();

    drawHeader();

    pushMatrix();
    translate(0, lives_height);
    for(int y = 0; y < tiles_count; y++){
        for(int x = 0; x < tiles_count; x++){
            imageCells[y][x].show();
        }
        valueCellsX[y].show(0, tile_width * 2);
        valueCellsY[y].show(tile_width * 2, 0);
    }
    popMatrix();
}

void drawHeader(){
    fill(0);
    textAlign(LEFT);
    textSize(lives_height/2);
    text("Lives: " + lives_remaining, 50, lives_height/2);

    for(int i = 0; i < clickModeCells.size(); i++){
        clickModeCells.get(i).show(i);
    }
}

void mouseDragged(){
    mousePressed();
}

void mousePressed(){
    boolean found = false;
    for(int y = 0; y < tiles_count; y++){
        for(int x = 0; x < tiles_count; x++){
            if(imageCells[y][x].mousePressed(mouseX, mouseY - lives_height) && !imageCells[y][x].isClicked()){
                if(imageCells[y][x].showColor(selectedColor)){
                    checkColRow(x, y);
                }else{
                    lives_remaining--;
                    if(lives_remaining == 0){
                        newGame();
                    }
                }
                found = true;
                break;
            }
        }
        if(found) break;
    }

    if(!found){
        checkClickMode();
    }
}

void checkClickMode(){
    int selectedIndex = -1;
    for(int i = 0; i < clickModeCells.size(); i++){
        if(clickModeCells.get(i).mousePressed(mouseX, mouseY)){
            selectedIndex = i;
            selectedColor = clickModeCells.get(i).getColor();
        }
    }

    if(selectedIndex >= 0){
        for(int i = 0; i < clickModeCells.size(); i++){
            clickModeCells.get(i).selectToggle(selectedIndex == i);
        }
    }
}

void checkColRow(int x, int y){
    boolean colsRemaining = false, rowsRemaining = false;

    for(int i = 0; i < tiles_count; i++){
        if(image[y][i] != 0 && !imageCells[y][i].isClicked()){
            colsRemaining = true;
        }
        if(image[i][x] != 0 && !imageCells[i][x].isClicked()){
            rowsRemaining = true;
        }
    }
    if(!colsRemaining){
        for(int i = 0; i < tiles_count; i++){
            if(image[y][i] == 0){
                imageCells[y][i].mark();
            }
        }
    }
    if(!rowsRemaining){
        for(int i = 0; i < tiles_count; i++){
            if(image[i][x] == 0){
                imageCells[i][x].mark();
            }
        }
    }
}

//TODO if start/end of row/column is marked/colored and till colored cell, change color or text
//TODO import image and convert into binary matrix

void addValues(){
    for(int i = 0; i < tiles_count; i++){
        int vX = 0;
        int vY = 0;
        color thisColorY = 0, thisColorX = 0;
        for(int j = 0; j < tiles_count; j++){
            if(image[j][i] != 0 && thisColorY == 0){ // first cell with this color
                vY++;
                thisColorY = image[j][i];
            }else if(image[j][i] != 0 && thisColorY == image[j][i]){
                vY++;
            }else if(image[j][i] != 0){ // color has changed
                valueCellsY[i].addValue(String.valueOf(vY), thisColorY);
                thisColorY = image[j][i];
                vY = 1;
            }else if(image[j][i] == 0 && vY > 0){
                valueCellsY[i].addValue(String.valueOf(vY), thisColorY);
                vY = 0;
                thisColorY = 0;
            }

            if(image[i][j] != 0 && thisColorX == 0){
                vX++;
                thisColorX = image[i][j];
            }else if(image[i][j] != 0 && thisColorX == image[i][j]){
                vX++;
            }else if(image[i][j] != 0){ // color has changed
                valueCellsX[i].addValue(String.valueOf(vX), thisColorX);
                thisColorX = image[i][j];
                vX = 1;
            }else if(image[i][j] == 0 && vX > 0){
                valueCellsX[i].addValue(String.valueOf(vX), thisColorX);
                vX = 0;
                thisColorX = 0;
            }

            if(j == (tiles_count - 1) && vY > 0){
                valueCellsY[i].addValue(String.valueOf(vY), thisColorY);
            }
            if(j == (tiles_count - 1) && vX > 0){
                valueCellsX[i].addValue(String.valueOf(vX), thisColorX);
            }
        }
        
    }
    // for(int i = 0; i < tiles_count; i++){
    //     String vals = "";
    //     for(int j = 0; j < valueCellsX[i].nextString; j++){
    //         vals += valueCellsX[i].values[j] + " ";
    //     }
    // }
    
}