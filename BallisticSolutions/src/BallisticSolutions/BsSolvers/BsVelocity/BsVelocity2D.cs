using System.Numerics;

namespace BallisticSolutions.BsSolvers.BsVelocity;

/// <inheritdoc cref="BsVelocity4D"/>
public static class BsVelocity2D {
	/// <inheritdoc cref="BsVelocity4D.Velocity{T}"/>
	public static Vector2 Velocity<T>(T time, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) where T : INumber<T>
		=> BsVelocity4D.Velocity(time, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).ToVector2();

	/// <inheritdoc cref="BsVelocity4D.Best(float, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector2 Best(float projectileSpeed, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default)
		=> BsVelocity4D.Best(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).ToVector2();

	/// <inheritdoc cref="BsVelocity4D.Best(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector2 Best(Vector2 projectileDirection, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default)
		=> BsVelocity4D.Best(projectileDirection.ToVector4(), toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).ToVector2();

	/// <inheritdoc cref="BsVelocity4D.All(float, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector2[] All(float projectileSpeed, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default)
		=> [.. BsVelocity4D.All(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).Select(static v => v.ToVector2())];

	/// <inheritdoc cref="BsVelocity4D.All(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector2[] All(Vector2 projectileDirection, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default)
		=> [.. BsVelocity4D.All(projectileDirection.ToVector4(), toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).Select(static v => v.ToVector2())];
}
