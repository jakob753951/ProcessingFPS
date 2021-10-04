public ArrayList<MapObject> scene;
public Camera cam;

void setup() {
	size(800, 600);
	cam = new Camera(new PVector(05, 15), 0);
	createMap();
	lastMillis = millis();
}

void createMap() {
	scene = new ArrayList<MapObject>();
	scene.add(new Circle(new PVector(20, 20), 2));
	scene.add(new Circle(new PVector(10, 20), 2));
	scene.add(new Circle(new PVector(20, 10), 2));
	scene.add(new Circle(new PVector(10, 10), 2));
	scene.add(new Rectangle(12.5, 12.5, 17.5, 17.5));
	scene.add(cam);
}

private boolean isTurningLeft = false;
private boolean isTurningRight = false;
private boolean isMovingForward = false;
private boolean isMovingBack = false;
private boolean isMovingLeft = false;
private boolean isMovingRight = false;


void keyPressed()	{ keyEvent(true); }

void keyReleased()	{ keyEvent(false); }

void keyEvent(boolean isPressed) {
	if (key == CODED && keyCode == LEFT)	isTurningLeft = isPressed;
	if (key == CODED && keyCode == RIGHT)	isTurningRight = isPressed;
	if (key == 'w' || key == 'W')			isMovingForward = isPressed;
	if (key == 's' || key == 'S')			isMovingBack = isPressed;
	if (key == 'a' || key == 'A')			isMovingLeft = isPressed;
	if (key == 'd' || key == 'D')			isMovingRight = isPressed;
}

private int lastMillis;

void draw() {
	float deltaTime = (((float)millis()-lastMillis) / 1000);
	lastMillis = millis();
	println(1/deltaTime);
	if (isTurningLeft)   cam.turnLeft(deltaTime);
	if (isTurningRight)  cam.turnRight(deltaTime);
	if (isMovingForward) cam.moveForward(deltaTime, scene);
	if (isMovingBack)    cam.moveBack(deltaTime, scene);
	if (isMovingLeft)    cam.moveLeft(deltaTime, scene);
	if (isMovingRight)   cam.moveRight(deltaTime, scene);

	cam.render(scene);
	// drawDistanceMap();
	// drawMap();
}

void drawMap() {
	background(0);
	for (MapObject o : scene) {
		o.draw();
	}
}

void drawDistanceMap() {
	loadPixels();

	int x, y;
	for (int i = 0; i < pixels.length; i++) {
		x = i % width;
		y = i / width;
		float dist = Utils.distanceToScene(new PVector(x/10., y/10.), scene);
		float mouseXScale = (float)mouseX/width;
		float mouseYScale = (float)mouseY/height;
		float col = mouseYScale*255*2-(dist*255);
		pixels[i] = color(col, col, col);
	}

	updatePixels();
}