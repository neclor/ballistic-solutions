using System.Numerics;
using BallisticSolutions.BsSolvers.BsTime;

namespace BallisticSolutions.BsSolvers.BsVelocity;

/// <summary>
/// Provides methods for computing required firing velocities.
/// </summary>
public static class BsVelocity4D {
	/// <inheritdoc cref="BsEquations4D.Velocity{T}"/>
	public static Vector4 Velocity<T>(T time, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : INumber<T>
		=> BsEquations4D.Velocity(time, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);

	/// <summary>
	/// Computes the firing velocity required for the earliest valid interception.
	/// </summary>
	/// <param name="projectileSpeed">The speed of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// The required firing velocity vector. Returns `NaN` vector if interception is impossible.
	/// </returns>
	public static Vector4 Best(float projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default)
		=> Velocity(BsTime4D.Best<float>(projectileSpeed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration), toTarget, targetVelocity, projectileAcceleration, targetAcceleration);

	/// <summary>
	/// Computes the firing velocity required for the earliest valid interception.
	/// </summary>
	/// <param name="projectileDirection">The direction of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// The required firing velocity vector. Returns `NaN` vector if interception is impossible.
	/// </returns>
	public static Vector4 Best(Vector4 projectileDirection, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default)
		=> Velocity(BsTime4D.Best<float>(projectileDirection, toTarget, targetVelocity, projectileAcceleration, targetAcceleration), toTarget, targetVelocity, projectileAcceleration, targetAcceleration);

	/// <summary>
	/// Computes firing velocities for all valid interception times.
	/// </summary>
	/// <param name="projectileSpeed">The speed of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// An array of firing velocity vectors, one for each valid interception time.
	/// </returns>
	public static Vector4[] All(float projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default)
		=> [
			.. BsTime4D.All<float>(projectileSpeed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration)
				.Select(t => Velocity(t, toTarget, targetVelocity, projectileAcceleration, targetAcceleration))
		];

	/// <summary>
	/// Computes firing velocities for all valid interception times.
	/// </summary>
	/// <param name="projectileDirection">The direction of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// An array of firing velocity vectors, one for each valid interception time.
	/// </returns>
	public static Vector4[] All(Vector4 projectileDirection, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default)
		=> [
			.. BsTime4D.All<float>(projectileDirection, toTarget, targetVelocity, projectileAcceleration, targetAcceleration)
				.Select(t => Velocity(t, toTarget, targetVelocity, projectileAcceleration, targetAcceleration))
		];
}
