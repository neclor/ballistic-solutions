namespace BallisticSolutions.BsVectorExtensions;

/// <summary>
/// Extension methods for working with <see cref="Vector4"/>.
/// </summary>
public static class BsVector4Extensions {
#if GODOT
	private static readonly Vector4 _nan = new(float.NaN, float.NaN, float.NaN, float.NaN);
#endif

#pragma warning disable CA1034
	extension(Vector4 v) {
#pragma warning restore CA1034

#if GODOT
		/// <summary>
		/// Gets a vector with NaN (Not a Number) values.
		/// </summary>
		public static Vector4 NaN => _nan;
#endif

		/// <summary>
		/// Creates a four-dimensional vector from a two-dimensional vector with specified Z and W components.
		/// </summary>
		/// <param name="from">The source two-dimensional vector.</param>
		/// <param name="z">The Z component value (default is 0).</param>
		/// <param name="w">The W component value (default is 0).</param>
		/// <returns>A new four-dimensional vector.</returns>
		public static Vector4 From(Vector2 from, float z = 0f, float w = 0f) => from.ToVector4(z, w);

		/// <summary>
		/// Creates a four-dimensional vector from a three-dimensional vector with a specified W component.
		/// </summary>
		/// <param name="from">The source three-dimensional vector.</param>
		/// <param name="w">The W component value (default is 0).</param>
		/// <returns>A new four-dimensional vector.</returns>
		public static Vector4 From(Vector3 from, float w = 0f) => from.ToVector4(w);

		/// <summary>
		/// Converts the four-dimensional vector to a two-dimensional vector using only X and Y components.
		/// </summary>
		/// <returns>A new two-dimensional vector with X and Y components.</returns>
		public Vector2 ToVector2() => new(v.X, v.Y);

		/// <summary>
		/// Converts the four-dimensional vector to a three-dimensional vector using only X, Y, and Z components.
		/// </summary>
		/// <returns>A new three-dimensional vector with X, Y, and Z components.</returns>
		public Vector3 ToVector3() => new(v.X, v.Y, v.Z);

#if !GODOT
		/// <summary>
		/// Returns the dot product of this vector and <paramref name="with"/>.
		/// </summary>
		/// <param name="with">The other vector to use.</param>
		/// <returns>The dot product of the two vectors.</returns>
		public float Dot(Vector4 with) => Vector4.Dot(v, with);

		/// <summary>
		/// Returns the vector scaled to unit length.
		/// </summary>
		/// <returns>A normalized version of the vector.</returns>
		public Vector4 Normalized() => v.LengthSquared() == 0f ? Vector4.Zero : Vector4.Normalize(v);
#endif
	}
}
