public static class Utils {
	public static float distance(PVector a, PVector b) {
		return length(subtract(a, b));
	}

	public static float degToRad(float degrees) {
		return degrees/360*TAU;
	}

	public static float radToDeg(float radians) {
		return radians/TAU*360;
	}

	public static PVector add(PVector a, PVector b) {
		return new PVector(a.x+b.x, a.y+b.y);
	}

	public static PVector subtract(PVector a, PVector b) {
		return new PVector(a.x-b.x, a.y-b.y);
	}

	public static float length(PVector a) {
		return sqrt(a.x * a.x + a.y * a.y);
	}

	public static PVector multiply(PVector vec, float scalar) {
		return new PVector(vec.x * scalar, vec.y * scalar);
	}

	public static float min(float a, float b) {
		return a < b ? a : b;
	}

	public static PVector min(PVector a, PVector b) {
		return new PVector(min(a.x, b.x), min(a.y, b.y));
	}

	public static float max(float a, float b) {
		return a > b ? a : b;
	}

	public static PVector max(PVector a, PVector b) {
		return new PVector(max(a.x, b.x), max(a.y, b.y));
	}

	public static float distanceToScene(PVector p, ArrayList<MapObject> scene) {
		float minDist = Float.MAX_VALUE;
		for (MapObject o : scene) {
			if (o instanceof Camera) continue;
			float dist = o.distanceTo(p);
			if (dist < minDist) minDist = dist;
		}
		return minDist;
	}
}
