#if GODOT
using Vector2 = Godot.Vector2;
using Vector3 = Godot.Vector3;
using Vector4 = Godot.Vector4;
#else
using Vector2 = System.Numerics.Vector2;
using Vector3 = System.Numerics.Vector3;
using Vector4 = System.Numerics.Vector4;
#endif

namespace BallisticSolutions.BsVectorExtensions;

/// <summary>
/// Extension methods for working with Vector2.
/// </summary>
public static class BsVector2Extensions {

#if GODOT
	private static readonly Vector2 _nan = new(float.NaN, float.NaN);
#endif

#pragma warning disable CA1034
	extension(Vector2 v) {
#pragma warning restore CA1034

#if GODOT
		/// <summary>
		/// Gets a vector with NaN (Not a Number) values.
		/// </summary>
		public static Vector2 NaN => _nan;
#endif

		/// <summary>
		/// Creates a two-dimensional vector from a three-dimensional vector using only X and Y components.
		/// </summary>
		/// <param name="from">The source three-dimensional vector.</param>
		/// <returns>A new two-dimensional vector with X and Y components.</returns>
		public static Vector2 From(Vector3 from) => from.ToVector2();

		/// <summary>
		/// Creates a two-dimensional vector from a four-dimensional vector using only X and Y components.
		/// </summary>
		/// <param name="from">The source four-dimensional vector.</param>
		/// <returns>A new two-dimensional vector with X and Y components.</returns>
		public static Vector2 From(Vector4 from) => from.ToVector2();

		/// <summary>
		/// Converts the two-dimensional vector to a three-dimensional vector with a specified Z component.
		/// </summary>
		/// <param name="z">The Z component value (default is 0).</param>
		/// <returns>A new three-dimensional vector.</returns>
		public Vector3 ToVector3(float z = 0f) => new(v.X, v.Y, z);

		/// <summary>
		/// Converts the two-dimensional vector to a four-dimensional vector with specified Z and W components.
		/// </summary>
		/// <param name="z">The Z component value (default is 0).</param>
		/// <param name="w">The W component value (default is 0).</param>
		/// <returns>A new four-dimensional vector.</returns>
		public Vector4 ToVector4(float z = 0f, float w = 0f) => new(v.X, v.Y, z, w);
	}
}
