public class Camera extends MapObject {
	public float rotation;
	public float fov;
	public float moveSpeed;
	public float turnSpeed;

	public float MIN_DIST = 0.0001;
	public float MAX_DIST = 9999f;
	public float MAX_STEPS = 3000;

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

	public void turnLeft(float deltaTime) {
		this.rotation -= turnSpeed * deltaTime;
	}

	public void turnRight(float deltaTime) {
		this.rotation += turnSpeed * deltaTime;
	}

	public void moveForward(float deltaTime, ArrayList<MapObject> scene) {
		PVector lastPos = this.pos;
		this.pos = new PVector(pos.x + (cos(rotation) * moveSpeed * deltaTime), pos.y+(sin(rotation)*moveSpeed * deltaTime));
		if (Utils.distanceToScene(this.pos, scene) < 0) {
			this.pos = lastPos;
		}
	}

	public void moveBack(float deltaTime, ArrayList<MapObject> scene) {
		PVector lastPos = this.pos;
		this.pos = new PVector(pos.x-(cos(rotation)*moveSpeed * deltaTime), pos.y-(sin(rotation)*moveSpeed * deltaTime));
		if (Utils.distanceToScene(this.pos, scene) < 0) {
			this.pos = lastPos;
		}
	}

	public void moveLeft(float deltaTime, ArrayList<MapObject> scene) {
		PVector lastPos = this.pos;
		this.pos = new PVector(pos.x+(sin(rotation)*moveSpeed * deltaTime), pos.y-(cos(rotation)*moveSpeed * deltaTime));
		if (Utils.distanceToScene(this.pos, scene) < 0) {
			this.pos = lastPos;
		}
	}

	public void moveRight(float deltaTime, ArrayList<MapObject> scene) {
		PVector lastPos = this.pos;
		this.pos = new PVector(pos.x-(sin(rotation)*moveSpeed * deltaTime), pos.y+(cos(rotation)*moveSpeed * deltaTime));
		if (Utils.distanceToScene(this.pos, scene) < 0) {
			this.pos = lastPos;
		}
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

	public void draw() {
		stroke(255);
		float lineLength = 10;
		float leftLineAngle = this.rotation - Utils.degToRad(this.fov/2);
		float rightLineAngle = this.rotation + Utils.degToRad(this.fov/2);
		circle(this.pos.x * 10, this.pos.y * 10, 5);
		line(this.pos.x * 10, this.pos.y * 10, 10 * this.pos.x + (cos(leftLineAngle) * lineLength), 10 * this.pos.y + (sin(leftLineAngle) * lineLength));
		line(this.pos.x * 10, this.pos.y * 10, 10 * this.pos.x + (cos(rightLineAngle) * lineLength), 10 * this.pos.y + (sin(rightLineAngle) * lineLength));
	}
}
