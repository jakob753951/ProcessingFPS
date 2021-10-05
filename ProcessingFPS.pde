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

private int lastMillis;

void draw() {
	float deltaTime = (((float)millis()-lastMillis) / 1000);
	lastMillis = millis();
	println(1/deltaTime);
	cam.doMovement(scene, deltaTime);
	background(0);
	cam.render(scene);
	// drawDistanceMap();
	// drawMap();
}

void drawMap() {
	float scalingFactor = 10;
	for (MapObject o : scene) {
		o.draw(scalingFactor);
	}
}

void keyPressed() { cam.keyEvent(true); }

void keyReleased() { cam.keyEvent(false); }

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
