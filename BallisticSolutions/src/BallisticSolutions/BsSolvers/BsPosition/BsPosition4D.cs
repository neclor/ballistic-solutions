using System.Numerics;
using BallisticSolutions.BsSolvers.BsTime;
#if GODOT
using Vector4 = Godot.Vector4;
#else
using Vector4 = System.Numerics.Vector4;
#endif

namespace BallisticSolutions.BsSolvers.BsPosition;

/// <summary>
/// Provides methods for computing projectile positions, impact positions, and displacement calculations.
/// </summary>
public static class BsPosition4D {
	/// <inheritdoc cref="BsEquations4D.Displacement{T}"/>
	public static Vector4 Displacement<T>(T time, Vector4 velocity, Vector4 acceleration = default) where T : INumber<T>
		=> BsEquations4D.Displacement(time, velocity, acceleration);

	/// <inheritdoc cref="BsEquations4D.Position{T}"/>
	public static Vector4 Position<T>(Vector4 position, T time, Vector4 velocity, Vector4 acceleration = default) where T : INumber<T>
		=> BsEquations4D.Position(position, time, velocity, acceleration);

	/// <summary>
	/// Computes the impact position of the earliest valid interception.
	/// </summary>
	/// <param name="projectileSpeed">The speed of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// The impact position vector. Returns `NaN` vector if interception is impossible.
	/// </returns>
	public static Vector4 Best(float projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default)
		=> Position(toTarget, BsTime4D.Best<float>(projectileSpeed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration), targetVelocity, targetAcceleration);

	/// <summary>
	/// Computes the impact position of the earliest valid interception.
	/// </summary>
	/// <param name="projectileDirection">The direction of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// The impact position vector. Returns `NaN` vector if interception is impossible.
	/// </returns>
	public static Vector4 Best(Vector4 projectileDirection, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default)
		=> Position(toTarget, BsTime4D.Best<float>(projectileDirection, toTarget, targetVelocity, projectileAcceleration, targetAcceleration), targetVelocity, targetAcceleration);

	/// <summary>
	/// Computes all possible impact positions corresponding to valid interception times.
	/// </summary>
	/// <param name="projectileSpeed">The speed of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// An array of vectors representing all valid impact positions.
	/// </returns>
	public static Vector4[] All(float projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default)
		=> [
			.. BsTime4D.All<float>(projectileSpeed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration)
				.Select(t => Position(toTarget, t, targetVelocity, targetAcceleration))
		];

	/// <summary>
	/// Computes all possible impact positions corresponding to valid interception times.
	/// </summary>
	/// <param name="projectileDirection">The direction of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// An array of vectors representing all valid impact positions.
	/// </returns>
	public static Vector4[] All(Vector4 projectileDirection, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default)
		=> [
			.. BsTime4D.All<float>(projectileDirection, toTarget, targetVelocity, projectileAcceleration, targetAcceleration)
				.Select(t => Position(toTarget, t, targetVelocity, targetAcceleration))
		];
}
