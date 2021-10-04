public class Circle extends MapObject {
	public float radius;

	public Circle(PVector pos, float radius) {
		this.pos = pos;
		this.radius = radius;
	}

	public float distanceTo(PVector p) {
		return Utils.distance(p, this.pos) - this.radius;
	}

	public void draw() {
		circle(pos.x * 10, pos.y * 10, radius * 10);
	}
}
