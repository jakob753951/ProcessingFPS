public class Rectangle extends MapObject {
	public PVector mins;
	public PVector maxs;

	public Rectangle(float minX, float minY, float maxX, float maxY) {
		this.mins = new PVector(minX, minY);
		this.maxs = new PVector(maxX, maxY);
		this.pos = new PVector(maxX-minX, maxY-minY);
	}

	public float distanceTo(PVector p) {
		float dx = max(mins.x - p.x, 0, p.x - maxs.x);
		float dy = max(mins.y - p.y, 0, p.y - maxs.y);
		return sqrt(dx*dx + dy*dy);
	}

	public void draw() {
		rect(mins.x * 10, mins.y * 10, (maxs.x-mins.x) * 10, (maxs.y-mins.y) * 10);
	}
}
