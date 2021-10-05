public class Camera extends MapObject {
	public float rotation;
	public float fov;
	public float moveSpeed;
	public float turnSpeed;

	public float MIN_DIST = 0.0001;
	public float MAX_DIST = 9999f;
	public float MAX_STEPS = 3000;

	private boolean isTurningLeft = false;
	private boolean isTurningRight = false;
	private boolean isMovingForward = false;
	private boolean isMovingBack = false;
	private boolean isMovingLeft = false;
	private boolean isMovingRight = false;

	public void keyEvent(boolean isPressed) {
		if (key == CODED && keyCode == LEFT)	isTurningLeft = isPressed;
		if (key == CODED && keyCode == RIGHT)	isTurningRight = isPressed;
		if (key == 'w' || key == 'W')			isMovingForward = isPressed;
		if (key == 's' || key == 'S')			isMovingBack = isPressed;
		if (key == 'a' || key == 'A')			isMovingLeft = isPressed;
		if (key == 'd' || key == 'D')			isMovingRight = isPressed;
	}

	public Camera(PVector pos, float rotation) {
		this.pos = pos;
		this.rotation = rotation;
		this.fov = 90;
		this.moveSpeed = 10;
		this.turnSpeed = 2.5;
	}

	public float distanceTo(PVector p) {
		return Utils.distance(p, this.pos);
	}

	public void doMovement(ArrayList<MapObject> scene, float deltaTime) {
		PVector lastPos = this.pos;
		PVector deltaPos = new PVector(0, 0);
		float deltaRotation = 0;
		if (isTurningLeft)   deltaRotation += cam.turnLeft();
		if (isTurningRight)  deltaRotation += cam.turnRight();
		if (isMovingForward) deltaPos = Utils.add(deltaPos, cam.moveForward());
		if (isMovingBack)    deltaPos = Utils.add(deltaPos, cam.moveBack());
		if (isMovingLeft)    deltaPos = Utils.add(deltaPos, cam.moveLeft());
		if (isMovingRight)   deltaPos = Utils.add(deltaPos, cam.moveRight());
		deltaPos = Utils.multiply(deltaPos,  moveSpeed * deltaTime);
		
		this.rotation += deltaRotation * deltaTime;
		this.pos = Utils.add(this.pos, deltaPos);
		collisionCheck(scene, deltaTime, lastPos);
	}

	public float turnLeft() {
		return -turnSpeed;
	}

	public float turnRight() {
		return turnSpeed;
	}

	public PVector moveForward() {
		return new PVector(cos(rotation), sin(rotation));
	}

	public PVector moveBack() {
		return new PVector(-(cos(rotation)), -(sin(rotation)));
	}

	public PVector moveLeft() {
		return new PVector(sin(rotation), -(cos(rotation)));
	}

	public PVector moveRight() {
		return new PVector(-(sin(rotation)), cos(rotation));
	}

	public void collisionCheck(ArrayList<MapObject> scene, float deltaTime, PVector lastPos) {
		if (Utils.distanceToScene(this.pos, scene) < 0) {
			MapObject colliding = getCollidingObject(scene);
			try {
				PVector deltaPos = Utils.multiply(colliding.normalAt(this.pos), deltaTime * moveSpeed);
				this.pos = Utils.add(this.pos, deltaPos);
			} catch (IllegalArgumentException e) {
				this.pos = lastPos;
			}
		}
	}

	private MapObject getCollidingObject(ArrayList<MapObject> scene) {
		for (MapObject o : scene) {
			if (o.distanceTo(this.pos) < 0)
				return o;
		}
		return null;
	}

	float distanceToObjectHit(PVector p, float angle, ArrayList<MapObject> scene, int stepsTaken) {
		float stepSize = Utils.distanceToScene(p, scene);
		if (stepSize < MIN_DIST || MAX_DIST < stepSize || stepsTaken > MAX_STEPS)
			return 0;
		PVector newP = new PVector(p.x+(cos(angle)*stepSize), p.y+(sin(angle)*stepSize));

		return stepSize + distanceToObjectHit(newP, angle, scene, stepsTaken + 1);
	}

	float getHeight(int x, ArrayList<MapObject> scene) {
		float minAngle = Utils.degToRad(this.fov/2);
		//println(((float)(x-(width/2)) / (width/2)) * minAngle);
		float angle = ((float)(x-(width/2)) / (width/2)) * minAngle + this.rotation;
		float dist = distanceToObjectHit(this.pos, angle, scene, 0);
		float h = (1/dist);
		//println(angle + ": " + dist + ": " + h);
		return h;
	}

	public void render(ArrayList<MapObject> scene) {
		loadPixels();
		for (int x = 0; x < width; x++) {
			float lineHeight = getHeight(x, scene);
			for (int y = 0; y < height/2; y++) {
				float bc = height/4-y;
				float fc = 255*lineHeight;
				color blankColor = color(bc, bc, bc);
				color fillColor = color(fc, fc, fc);
				color col = y > height/2 - lineHeight*height/2 ? fillColor : blankColor;
				pixels[y*width + x] = col;
				pixels[((width*height-width)-(y*width)) + x] = col;
			}
		}
		updatePixels();
	}

	public void draw(float scalingFactor) {
		stroke(255);
		float lineLength = scalingFactor;
		float leftLineAngle = this.rotation - Utils.degToRad(this.fov/2);
		float rightLineAngle = this.rotation + Utils.degToRad(this.fov/2);
		circle(this.pos.x * scalingFactor, this.pos.y * scalingFactor, scalingFactor/2);
		line(this.pos.x * scalingFactor, this.pos.y * scalingFactor, scalingFactor * this.pos.x + (cos(leftLineAngle) * lineLength), scalingFactor * this.pos.y + (sin(leftLineAngle) * lineLength));
		line(this.pos.x * scalingFactor, this.pos.y * scalingFactor, scalingFactor * this.pos.x + (cos(rightLineAngle) * lineLength), scalingFactor * this.pos.y + (sin(rightLineAngle) * lineLength));
	}

	public PVector normalAt(PVector p) throws IllegalArgumentException {
		throw new IllegalArgumentException();
	}
}
