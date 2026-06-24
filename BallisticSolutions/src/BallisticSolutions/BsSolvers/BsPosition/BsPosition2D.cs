using System.Numerics;

namespace BallisticSolutions.BsSolvers.BsPosition;

/// <inheritdoc cref="BsPosition4D"/>
public static class BsPosition2D {
	/// <inheritdoc cref="BsPosition4D.Displacement{T}"/>
	public static Vector2 Displacement<T>(T time, Vector2 velocity, Vector2 acceleration = default) where T : INumber<T>
		=> BsPosition4D.Displacement(time, velocity.ToVector4(), acceleration.ToVector4()).ToVector2();

	/// <inheritdoc cref="BsPosition4D.Position{T}"/>
	public static Vector2 Position<T>(Vector2 position, T time, Vector2 velocity, Vector2 acceleration = default) where T : INumber<T>
		=> BsPosition4D.Position(position.ToVector4(), time, velocity.ToVector4(), acceleration.ToVector4()).ToVector2();

	/// <inheritdoc cref="BsPosition4D.Best(float, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector2 Best(float projectileSpeed, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default)
		=> BsPosition4D.Best(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).ToVector2();

	/// <inheritdoc cref="BsPosition4D.Best(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector2 Best(Vector2 projectileDirection, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default)
		=> BsPosition4D.Best(projectileDirection.ToVector4(), toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).ToVector2();

	/// <inheritdoc cref="BsPosition4D.All(float, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector2[] All(float projectileSpeed, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default)
		=> [.. BsPosition4D.All(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).Select(static p => p.ToVector2())];

	/// <inheritdoc cref="BsPosition4D.All(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector2[] All(Vector2 projectileDirection, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default)
		=> [.. BsPosition4D.All(projectileDirection.ToVector4(), toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).Select(static p => p.ToVector2())];
}
