float radius = 1; //Radius of the circle that will be used to map
int winSize = 1000; //Window size in pixels
float renderSpace = 4; //Size of the environment to be rendered (ex. 5 will render -5 to 5 for both X and Y axiis)

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

//Misc other varables
float distance;
float slope;

void setup() {
  size(winSize, winSize); //Set window size
  background(255); //Set background to white
  smooth(4); //Anti-Aliasing
  noLoop(); //Only draw graph once
  
  //Append coordinates to origXY lists
  for (float i = 0.1; i < 0.7; i += 0.05) {
    origX.append(i);
    origY.append(-i + 0.5);
  }
  
  //Calculate and append XY mapped coordinates to newXY lists
  for (int i = 0; i < origX.size(); i++) {
    distance = radius / (sqrt(sq(origX.get(i)) + sq(origY.get(i))));
    slope = origY.get(i) / origX.get(i);
    
    newX.append(distance * cos(slope));
    println(distance * cos(slope));
    newY.append(distance * sin(slope));
  }
  
  //Map XY corrdinates to pixel coordinates
  for (int i = 0; i < origX.size(); i++) {
    //The mapping functions break if the min and max values are the same.
    //If the program crashes here or doesn't show any points, that's why.
    origPixelX.append(round(map(origX.get(i), -renderSpace, renderSpace, 0, winSize)));
    newPixelX.append(round(map(newX.get(i), -renderSpace, renderSpace, 0, winSize)));
    origPixelY.append(round(map(origY.get(i), -renderSpace, renderSpace, winSize, 0)));
    newPixelY.append(round(map(newY.get(i), -renderSpace, renderSpace, winSize, 0)));
  }
}

void draw() {
  ellipse(winSize / 2, winSize / 2, map(radius, 0, renderSpace, 0, winSize), map(radius, 0, renderSpace, 0, winSize)); //Circle that points were inverted about
  fill(0);
  ellipse(winSize / 2, winSize / 2, 4, 4);
  line(0, winSize / 2, winSize, winSize / 2);
  line(winSize / 2, 0, winSize / 2, winSize);
  //Loop until all points have been graphed
  for(int i = 0; i < origX.size(); i++) {
    stroke(#0000FF); //Set points to be blue
    fill(#0000FF); //Set point fill to be blue
    ellipse(origPixelX.get(i), origPixelY.get(i), 4, 4);
    stroke(#FF0000); //Set points to be red
    fill(#FF0000); //Set fill to be red
    ellipse(newPixelX.get(i), newPixelY.get(i), 4, 4);
  }
  save("Test.png");
  //exit();
}
