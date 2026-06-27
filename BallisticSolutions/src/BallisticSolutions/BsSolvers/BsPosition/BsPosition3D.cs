using System.Numerics;
#if GODOT
namespace BallisticSolutions.Godot.BsSolvers.BsPosition;
#else
namespace BallisticSolutions.BsSolvers.BsPosition;
#endif

/// <inheritdoc cref="BsPosition4D"/>
public static class BsPosition3D {
	/// <inheritdoc cref="BsPosition4D.Displacement{T}"/>
	public static Vector3 Displacement<T>(T time, Vector3 velocity, Vector3 acceleration = default) where T : INumber<T>
		=> BsPosition4D.Displacement(time, velocity.ToVector4(), acceleration.ToVector4()).ToVector3();

	/// <inheritdoc cref="BsPosition4D.Position{T}"/>
	public static Vector3 Position<T>(Vector3 position, T time, Vector3 velocity, Vector3 acceleration = default) where T : INumber<T>
		=> BsPosition4D.Position(position.ToVector4(), time, velocity.ToVector4(), acceleration.ToVector4()).ToVector3();

	/// <inheritdoc cref="BsPosition4D.Best(float, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector3 Best(float projectileSpeed, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default)
		=> BsPosition4D.Best(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).ToVector3();

	/// <inheritdoc cref="BsPosition4D.Best(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector3 Best(Vector3 projectileDirection, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default)
		=> BsPosition4D.Best(projectileDirection.ToVector4(), toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).ToVector3();

	/// <inheritdoc cref="BsPosition4D.All(float, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector3[] All(float projectileSpeed, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default)
		=> [.. BsPosition4D.All(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).Select(static p => p.ToVector3())];

	/// <inheritdoc cref="BsPosition4D.All(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector3[] All(Vector3 projectileDirection, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default)
		=> [.. BsPosition4D.All(projectileDirection.ToVector4(), toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).Select(static p => p.ToVector3())];
}
