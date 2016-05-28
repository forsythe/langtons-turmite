//OPTIONS
int delay = 0; //frames between each tick
boolean randDir = false; //should ants have random direction?

int[][] cells; //the actual cell, and the holding cell
int cellSize = 5; //size of each square in pixels
int numSquaresPerRow, numSquaresPerColumn;

int steps = 0;

int lastRecordedTime = 0;
boolean pause = true;

color taken = color(255, 255, 255);
color empty = color(0);
color antColor = color(255, 0, 0);

ArrayList<Termite> termites = new ArrayList<Termite>();

PFont f, fsmall;

String termiteSeed = "";
color[] colors;

void setup() {
  size(1800, 900);

  f = createFont("Arial", 30, true);
  fsmall = createFont("Arial", 20, true);
  textAlign(TOP);            

  numSquaresPerRow = height/cellSize;
  numSquaresPerColumn = width/cellSize;
  cells = new int[numSquaresPerRow][numSquaresPerColumn];

  fill(empty);
  stroke(empty);
  rect(0, 0, width, height);

  clearGrid();

  termiteSeed = javax.swing.JOptionPane.showInputDialog("Input termite movement pattern");
  colors = new color[termiteSeed.length()];

  for (int c = 0; c < termiteSeed.length(); c++) {
    colors[c] = color(int(random(256)), int(random(256)), int(random(256)));
  }
}

void draw() { 
  if (!pause) {
    if (millis()-lastRecordedTime>delay) { //delays between iterations so that one can see the individual generations
      iteration();
      lastRecordedTime = millis();
    }
  } else {
    redrawGrid();

    for (Termite t : termites) {
      drawTermite(t);
    }

    fill(taken);
    textFont(f);
    text("Paused", 15, 30);
    text("Step: " + steps, 15, 60);

    textFont(fsmall);
    text("Reset [R]", 15, 120);
    text("Pause/unpause [SPACE]", 15, 140);
    text("Spawn ant [Mouse]", 15, 160);
  }
}

void mouseClicked() {
  int mouseRow = int(map(mouseY, 0, height, 0, numSquaresPerRow));
  int mouseCol = int(map(mouseX, 0, width, 0, numSquaresPerColumn)); 

  termites.add(new Termite(mouseRow, mouseCol, randDir? int(random(4))*90 : 0, numSquaresPerRow, numSquaresPerColumn, termiteSeed));
  drawTermite(termites.get(termites.size()-1));
}

void iteration() {
  if (termites.size() == 0)
    return;

  for (Termite t : termites) {

    t.move(cells[t.r][t.c]);
    drawTermite(t);

    //color the cell from which the ant has left
    cells[t.r][t.c]++;
    cells[t.r][t.c]%=termiteSeed.length();

    fill(colors[cells[t.r][t.c]]);
    rect(t.c*cellSize, t.r*cellSize, cellSize, cellSize);
  }

  steps++;
}

void drawTermite(Termite t) {
  fill(antColor);
  rect(t.c*cellSize, t.r*cellSize, cellSize, cellSize);
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    clearGrid();
    termites.clear();

    fill(empty);
    stroke(empty);
    rect(0, 0, width, height);

    steps = 0;
  }

  if (key == ' ') {
    pause = !pause;

    if (!pause) {     //redraw to erase "paused" text
      redrawGrid();
      for (Termite t : termites) {
        drawTermite(t);
      }
    }
  }
}

void redrawGrid() {
  fill(empty);
  rect(0, 0, width, height);
  fill(taken);
  for (int r=0; r<numSquaresPerRow; r++) {
    for (int c=0; c<numSquaresPerColumn; c++) {
      if (cells[r][c] > 0) {
        fill(colors[cells[r][c]]);
        rect(c*cellSize, r*cellSize, cellSize, cellSize);
      }
    }
  }
}

void clearGrid() {
  for (int r=0; r<numSquaresPerRow; r++) 
    for (int c=0; c<numSquaresPerColumn; c++) 
      cells[r][c] = 0;
}