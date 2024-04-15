class Piece {
  int dim;
  int idx;
  boolean wasClicked;
  int xStickerCenterCoordinate;
  // s is the size to draw the boxes, leaving a gap of 2 on either side
  int s;
  int pieceLeftmostCoordinate;
  int pieceRightmostCoordinate;

  NMatrix orientation;
  int[] vec_position;

  Piece(int[] p, int idx) {
    vec_position = new int[p.length];
    for (int a = 0; a < p.length; a++) {
      vec_position[a] = p[a];
    }
    dim = p.length;
    orientation = new NMatrix(dim);
    this.idx = idx;
    wasClicked = false;
    
    s = (width/((int)pow(3,dim)/(int)pow(3, dim-1)))/((2*dim)+1);
    xStickerCenterCoordinate = (width/((int)pow(3,dim)/(int)pow(3, dim-1)))*(idx-(((int)pow(3,dim)-1)/2));
    pieceLeftmostCoordinate = (xStickerCenterCoordinate+(s/2))+(s*(dim-1));
    pieceRightmostCoordinate = (xStickerCenterCoordinate-(s/2))-(s*(dim-1));
    
  }

  // draw ALL of the sticker of the piece
  void draw() {
    rectMode(CENTER);
    strokeWeight(1);
    stroke(menu.black);

    // if the piece is in the clickBuffer, draw it with a bigger outline
    if (menu.puzzle.clickBuffer[0] == idx || menu.puzzle.clickBuffer[2] == idx) {
      stroke(menu.white);
      strokeWeight(5);
    }

    pushMatrix();

    // if the x sticker of the piece would be draw offscreen, don't draw it lol
    // offscreen culling not quite working, but pretty close!
    //if (abs(zoomwee)*(pieceLeftmostCoordinate+viewOffset) > abs(zoomwee)*((width/2)+viewOffset) || abs(zoomwee)*(pieceRightmostCoordinate+viewOffset) < abs(zoomwee)*((-1*(width/2)+viewOffset))) {
    //  popMatrix();
    //  return;
    //}


    //translate to x sticker of piece
    translate(xStickerCenterCoordinate, 0);


    for (int d = 1; d < dim+1; d++) {
      color c1 = menu.transparent;
      color c2 = menu.transparent;
      if (d==1) {
        if (vec_position[0]==0) fill(menu.transparent);
        if (vec_position[0]==1) fill(menu.red);
        if (vec_position[0]==-1) fill(menu.orange);
        rect(0, 0, s, s);
      } else {
        if (vec_position[d-1]==1) c1 = menu.posColours[d-1];
        else if (vec_position[d-1]==-1) c2 = menu.negColours[d-1];
        // draw 2 squares for the + and - axis stickers
        fill(c1);
        rect(s*(d-1), 0, s, s);
        fill(c2);
        rect(s*(-1*(d-1)), 0, s, s);
      }
    }

    popMatrix();
    strokeWeight(1);
    stroke(menu.black);
  }

  // returns the number of colours a piece has
  int getC() {
    int r = 0;
    for (int a = 0; a < dim; a++) {
      r += abs(vec_position[a]);
    }
    return r;
  }

  int[] getPos() {
    return orientation.multiply(vec_position);
  }

  // changes wasClicked to true if the piece was clicked on
  boolean clickCheck(float clickX, float clickY) {
    
    if (clickX < pieceLeftmostCoordinate && clickX > pieceRightmostCoordinate) {
      if (clickY < (s/2) && clickY > (-1)*(s/2)) {
        menu.puzzle.updateClickBuffer(idx);
        println("clicked " + menu.puzzle.clickBuffer[0] + ", " + menu.puzzle.clickBuffer[1] + " and " + menu.puzzle.clickBuffer[2] + ", " + menu.puzzle.clickBuffer[3]);
        wasClicked = true;
        return true;
      }
    }
    wasClicked = false;
    return false;
  }
}
