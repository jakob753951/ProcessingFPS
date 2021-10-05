public class Rectangle extends MapObject {
	public PVector mins;
	public PVector maxs;

	public Rectangle(float minX, float minY, float maxX, float maxY) {
		this.mins = new PVector(minX, minY);
		this.maxs = new PVector(maxX, maxY);
		this.pos = new PVector(maxX-minX, maxY-minY);
	}

	public float distanceTo(PVector p) {
		PVector d = Utils.max(Utils.subtract(mins, p), Utils.subtract(p, maxs));
		return Utils.length(Utils.max(new PVector(0.0, 0.0), d)) + Utils.min(0.0, Utils.max(d.x, d.y));
	}

	public void draw(float scalingFactor) {
		rect(mins.x * scalingFactor, mins.y * scalingFactor, (maxs.x-mins.x) * scalingFactor, (maxs.y-mins.y) * scalingFactor);
	}

	public PVector normalAt(PVector p) throws IllegalArgumentException{
		throw new IllegalArgumentException();
	}
}
