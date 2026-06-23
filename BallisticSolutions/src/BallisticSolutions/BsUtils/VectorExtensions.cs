using System.Numerics;

namespace BallisticSolutions.BsUtils;

internal static class VectorExtensions {
	extension(Vector2 v) {
		public Vector2 Normalized() => Vector2.Normalize(v);
	}

	extension(Vector3 v) {
		public Vector3 Normalized() => Vector3.Normalize(v);
	}

	extension(Vector4 v) {
		public Vector4 Normalized() => Vector4.Normalize(v);

		public float Dot(Vector4 with) => Vector4.Dot(v, with);
	}
}
