namespace BallisticSolutions.BsVectorExtensions;

/// <summary>
/// Extension methods for working with <see cref="Vector3"/>.
/// </summary>
public static class BsVector3Extensions {
#if GODOT
	private static readonly Vector3 _nan = new(float.NaN, float.NaN, float.NaN);
#endif

#pragma warning disable CA1034
	extension(Vector3 v) {
#pragma warning restore CA1034

#if GODOT
		/// <summary>
		/// Gets a vector with NaN (Not a Number) values.
		/// </summary>
		public static Vector3 NaN => _nan;
#endif

		/// <summary>
		/// Creates a three-dimensional vector from a two-dimensional vector with a specified Z component.
		/// </summary>
		/// <param name="from">The source two-dimensional vector.</param>
		/// <param name="z">The Z component value (default is 0).</param>
		/// <returns>A new three-dimensional vector.</returns>
		public static Vector3 From(Vector2 from, float z = 0f) => from.ToVector3(z);

		/// <summary>
		/// Creates a three-dimensional vector from a four-dimensional vector using only X, Y, and Z components.
		/// </summary>
		/// <param name="from">The source four-dimensional vector.</param>
		/// <returns>A new three-dimensional vector with X, Y, and Z components.</returns>
		public static Vector3 From(Vector4 from) => from.ToVector3();

		/// <summary>
		/// Converts the three-dimensional vector to a two-dimensional vector using only X and Y components.
		/// </summary>
		/// <returns>A new two-dimensional vector with X and Y components.</returns>
		public Vector2 ToVector2() => new(v.X, v.Y);

		/// <summary>
		/// Converts the three-dimensional vector to a four-dimensional vector with a specified W component.
		/// </summary>
		/// <param name="w">The W component value (default is 0).</param>
		/// <returns>A new four-dimensional vector.</returns>
		public Vector4 ToVector4(float w = 0f) => new(v.X, v.Y, v.Z, w);

#if !GODOT
		/// <summary>
		/// Returns the dot product of this vector and <paramref name="with"/>.
		/// </summary>
		/// <param name="with">The other vector to use.</param>
		/// <returns>The dot product of the two vectors.</returns>
		public float Dot(Vector3 with) => Vector3.Dot(v, with);

		/// <summary>
		/// Returns the vector scaled to unit length.
		/// </summary>
		/// <returns>A normalized version of the vector.</returns>
		public Vector3 Normalized() => v.LengthSquared() == 0f ? Vector3.Zero : Vector3.Normalize(v);
#endif
	}
}
