public class Circle extends MapObject {
	public float radius;

	public Circle(PVector pos, float radius) {
		this.pos = pos;
		this.radius = radius;
	}

	public float distanceTo(PVector p) {
		return Utils.distance(p, this.pos) - this.radius;
	}

	public void draw(float scalingFactor) {
		circle(pos.x * scalingFactor, pos.y * scalingFactor, radius * scalingFactor);
	}

	public PVector normalAt(PVector p) {
		return Utils.multiply(Utils.subtract(p, this.pos), 2/this.radius);
	}
}
