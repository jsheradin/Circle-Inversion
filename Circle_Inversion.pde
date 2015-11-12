//Changeable Variables
float radius = 1; //Radius of the circle that will be used to map
int winSize = 600; //Window size in pixels (window is square)
float renderSpace = 5; //Size of the environment to be rendered (ex. 5 will render -5 to 5 for both X and Y axiis)
int point = 1; //Radius of the points that will be plotted
String title = "Triangle"; //Name of whatever is being graphed
float res = 0.001; //Steps between points to graph (smaller the value, the higher the resolution)

//Lists for storing original values
FloatList origX = new FloatList();
FloatList origY = new FloatList();

//Lists for storing new values
FloatList newX = new FloatList();
FloatList newY = new FloatList();

//List for storing pixel coordinates (P primes)
FloatList newPixelX = new FloatList();
FloatList newPixelY = new FloatList();
FloatList origPixelX = new FloatList();
FloatList origPixelY = new FloatList();

//Misc other varables
float distance; //Length of line from origin to P prime
float theta; //Angle of the line from
float xLen;
float yLen;
float xSteps;
float ySteps;
float xDif;
float yDif;

void setup() {
  //Each line is one line of a triangle
  newLine(-0.5, -0.3, 0.0, 0.5);
  newLine(0.5, -0.3, 0.0, 0.5);
  newLine(-0.5, -0.3, 0.5, -0.3);
  
  size(winSize, winSize, P2D); //Set window size
  background(255); //Set background to white
  smooth(8); //Anti-Aliasing
  noLoop(); //Only draw graph once
  
  //Calculate and append XY mapped coordinates to newXY lists (this is where the magic happens)
  for (int i = 0; i < origX.size(); i++) {
    //Variables to store some of the calculations
    distance = sq(radius) / sqrt(sq(origX.get(i)) + sq(origY.get(i)));
    //Angle of the line
    theta = atan(origY.get(i) / origX.get(i));
    
    //Turn distance and theta into XY
    //The way the math is implemented will always return a positive X value even if it should be negative
    //This hack fixes that issue
    if (origX.get(i) >= 0) { //If X should be positive
      newX.append(distance * cos(theta));
      newY.append(distance * sin(theta));
    } else { //If X should be negative
      newX.append(distance * -cos(theta));
      newY.append(distance * -sin(theta));
    }
    
    /*
    //Debug Stuff - no longer needed
    println("\nOrigX: " + origX.get(i));
    println("OrigY: " + origY.get(i));
    println("Distance: " + distance);
    println("Theta: " + theta);
    println("NewX: " + newX.get(i));
    println("NewY: " + newY.get(i));
    */
  }
  
  //Map XY corrdinates to pixel coordinates
  for (int i = 0; i < origX.size(); i++) {
    origPixelX.append(map(origX.get(i), -renderSpace, renderSpace, 0, winSize)); //X of original point
    origPixelY.append(map(origY.get(i), -renderSpace, renderSpace, winSize, 0)); //Y of original point
    newPixelX.append(map(newX.get(i), -renderSpace, renderSpace, 0, winSize)); //X of mapped point
    newPixelY.append(map(newY.get(i), -renderSpace, renderSpace, winSize, 0)); //Y of mapped point
  }
}

void draw() {
  //Everything else on the graph but the points
  ellipse(winSize / 2, winSize / 2, map(radius, 0, renderSpace, 0, winSize), map(radius, 0, renderSpace, 0, winSize)); //Circle that points were inverted about
  fill(0); //Fill center point black
  ellipse(winSize / 2, winSize / 2, point, point); //Draw center point
  line(20, winSize / 2, winSize - 20, winSize / 2); //X axis line
  line(winSize / 2, 20, winSize / 2, winSize - 20); //Y axis line
  
  //Loop until all points have been graphed
  for(int i = 0; i < origX.size(); i++) {
    //Original Points
    stroke(#0000FF); //Set points to be blue
    fill(#0000FF); //Set point fill to be blue
    ellipse(origPixelX.get(i), origPixelY.get(i), point, point); //Plot original point
    
    //Prime Points
    stroke(#FF0000); //Set points to be red
    fill(#FF0000); //Set fill to be red
    ellipse(newPixelX.get(i), newPixelY.get(i), point, point); //Plot mapped point
    
    //Rays connecting the prime points to the origin through the original point (looks bad)
    //stroke(#00FF00); //Set line to green
    //line(newPixelX.get(i), newPixelY.get(i), winSize / 2, winSize / 2); //Draw line from point to origin through original point
    
  }
  save("Saved Graphs/" + title + ".png"); //Saves the graph as an image
  //exit(); //Closes the program
}

//Automated line maker
void newLine(float startX, float startY, float endX, float endY) {
  //Basic calculations
  xLen = endX - startX;
  yLen = endY - startY;
  xSteps = xLen / res;
  ySteps = yLen / res;
  
  //Increments to move the points along the line
  xDif = xLen / max(xSteps, ySteps);
  yDif = yLen / max(xSteps, ySteps);
  
  //Make points and append to list
  for (int i = 0; i < max(xSteps, ySteps); i++) {
    origX.append(startX + xDif * i);
    origY.append(startY + yDif * i);
  }
}
