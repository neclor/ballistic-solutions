#if GODOT
using Vector2 = Godot.Vector2;
using Vector3 = Godot.Vector3;
using Vector4 = Godot.Vector4;
#else
using Vector2 = System.Numerics.Vector2;
using Vector3 = System.Numerics.Vector3;
using Vector4 = System.Numerics.Vector4;
#endif

namespace BallisticSolutions.VectorExtensions;

internal static class Vector4Extensions {

#if GODOT
	private static readonly Vector4 _nan = new(float.NaN, float.NaN, float.NaN, float.NaN);
#endif

	extension(Vector4 v) {

#if GODOT
		public static Vector4 NaN => _nan;
#endif

		public Vector2 ToVector2() => new(v.X, v.Y);

		public Vector3 ToVector3() => new(v.X, v.Y, v.Z);

		public static Vector4 From(Vector2 from, float z = 0f, float w = 0f) => from.ToVector4(z, w);

		public static Vector4 From(Vector3 from, float w = 0f) => from.ToVector4(w);
	}
}
