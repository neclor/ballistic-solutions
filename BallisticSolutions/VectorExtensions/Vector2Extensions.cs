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


[System.Diagnostics.CodeAnalysis.SuppressMessage("Performance", "CA1822:Mark members as static")]
internal static class Vector2Extensions {

#if GODOT
	private static readonly Vector2 _nan = new Vector2(float.NaN, float.NaN);
#endif

	extension(Vector2 v) {

#if GODOT
		public static Vector2 NaN => _nan;
#endif

		public Vector3 ToVector3(float z = 0f) => new Vector3(v.X, v.Y, z);

		public Vector4 ToVector4(float z = 0f, float w = 0f) => new Vector4(v.X, v.Y, z, w);

		public static Vector2 From(Vector3 from) => from.ToVector2();

		public static Vector2 From(Vector4 from) => from.ToVector2();
	}
}
