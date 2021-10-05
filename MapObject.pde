public abstract class MapObject {
	public PVector pos;
	public abstract void draw(float scalingFactor);
	public abstract float distanceTo(PVector p);
	public abstract PVector normalAt(PVector p);
}
