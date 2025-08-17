#if USE_GODOT
	using Vector2 = Godot.Vector2;
	using Vector3 = Godot.Vector3;
	using Vector4 = Godot.Vector4;
#else
	using Vector2 = System.Numerics.Vector2;
	using Vector3 = System.Numerics.Vector3;
	using Vector4 = System.Numerics.Vector4;
#endif


namespace BallisticDeflectionCalculator;


[System.Diagnostics.CodeAnalysis.SuppressMessage("Performance", "CA1822:Mark members as static")]
internal static class Vector2Extensions {

	extension(Vector2 v) {
		public Vector3 ToVector3(float z = 0f) => new Vector3(v.X, v.Y, z);

		public Vector4 ToVector4(float z = 0f, float w = 0f) => new Vector4(v.X, v.Y, z, w);

		public static Vector2 From(Vector3 from) => from.ToVector2();

		public static Vector2 From(Vector4 from) => from.ToVector2();
	}
}


[System.Diagnostics.CodeAnalysis.SuppressMessage("Performance", "CA1822:Mark members as static")]
internal static class Vector3Extensions {

	extension(Vector3 v) {
		public Vector2 ToVector2() => new Vector2(v.X, v.Y);

		public Vector4 ToVector4(float w = 0f) => new Vector4(v.X, v.Y, v.Z, w);

		public static Vector3 From(Vector2 from, float z = 0f) => from.ToVector3(z);

		public static Vector3 From(Vector4 from) => from.ToVector3();
	}
}


[System.Diagnostics.CodeAnalysis.SuppressMessage("Performance", "CA1822:Mark members as static")]
internal static class Vector4Extensions {

	extension(Vector4 v) {
		public Vector2 ToVector2() => new Vector2(v.X, v.Y);

		public Vector3 ToVector3() => new Vector3(v.X, v.Y, v.Z);

		public static Vector4 From(Vector2 from, float z = 0f, float w = 0f) => from.ToVector4(z, w);

		public static Vector4 From(Vector3 from, float w = 0f) => from.ToVector4(w);
	}
}
