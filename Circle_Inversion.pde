float radius = 0.6; //Radius of the circle that will be used to map
int winSize = 2000; //Window size in pixels
float renderSpace = 8; //Size of the environment to be rendered (ex. 5 will render -5 to 5 for both X and Y axiis)

//Lists for storing original values
FloatList origX = new FloatList();
FloatList origY = new FloatList();

//Lists for storing new values
FloatList newX = new FloatList();
FloatList newY = new FloatList();

//List for storing pixel coordinates
FloatList newPixelX = new FloatList();
FloatList newPixelY = new FloatList();
FloatList origPixelX = new FloatList();
FloatList origPixelY = new FloatList();

void setup() {
  size(winSize, winSize); //Set window size
  background(255); //Set background to white
  smooth(4); //Anti-Aliasing
  noLoop(); //Only draw graph once
  
  //Append coordinates to origXY lists
  for (int i = 0; i < 9; i++) {
    origX.append(.1 * i - .4);
    origY.append(.4);
  }
  for (int i = 0; i < 8; i++) {
    origX.append(.1 * i - .4);
    origY.append(-.4);
  }
  for (int i = 0; i < 8; i++) {
    origX.append(.4);
    origY.append(.1 * i - .4);
  }
  for (int i = 0; i < 8; i++) {
    origX.append(-.4);
    origY.append(.1 * i - .4);
  }
  
  //Calculate and append XY mapped coordinates to newXY lists
  for (int i = 0; i < origX.size(); i++) {
    newX.append(radius / origX.get(i));
    newY.append(radius / origY.get(i));
  }
  
  //Map XY corrdinates to pixel coordinates
  for (int i = 0; i < origX.size(); i++) {
    //The mapping functions break if the min and max values are the same.
    //The only case where they are the same is if I am graphing on one of the axiis so it is just harcoded to the center.
    //This will break graphing a horizontal or vertical line if that is the only thing graphed.
    if (origX.min() != origX.max()) {
      origPixelX.append(round(map(origX.get(i), -renderSpace, renderSpace, 0, winSize)));
      newPixelX.append(round(map(newX.get(i), -renderSpace, renderSpace, 0, winSize)));
    } else {
      origPixelX.append(winSize / 2);
      newPixelX.append(winSize / 2);
    }
    if (origY.min() != origY.max()) {
      origPixelY.append(round(map(origY.get(i), -renderSpace, renderSpace, winSize, 0)));
      newPixelY.append(round(map(newY.get(i), -renderSpace, renderSpace, winSize, 0)));
    } else {
      origPixelY.append(winSize / 2);
      newPixelY.append(winSize / 2);
    }
  }
}

void draw() {
  fill(255);
  ellipse(winSize / 2, winSize / 2, map(radius, 0, renderSpace, 0, winSize), map(radius, 0, renderSpace, 0, winSize)); //Circle that points were inverted about
  fill(0);
  //Loop until all points have been graphed
  for(int i = 0; i < origX.size(); i++) {
    ellipse(origPixelX.get(i), origPixelY.get(i), 4, 4);
    ellipse(newPixelX.get(i), newPixelY.get(i), 4, 4);
  }
  save("Test.png");
  exit();
}
