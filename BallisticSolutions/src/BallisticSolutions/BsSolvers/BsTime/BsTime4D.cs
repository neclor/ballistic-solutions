using System.Numerics;
#if GODOT
namespace BallisticSolutions.Godot.BsSolvers.BsTime;
#else
namespace BallisticSolutions.BsSolvers.BsTime;
#endif

/// <summary>
/// Provides methods for computing interception times between a projectile and a moving target.
/// </summary>
public static class BsTime4D {
	/// <summary>
	/// Computes the earliest positive interception time between a projectile and a moving target.
	/// </summary>
	/// <typeparam name="T">A floating-point numeric type (e.g., float, double) implementing <see cref="IFloatingPointIeee754{T}"/>.</typeparam>
	/// <param name="projectileSpeed">The speed of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// The earliest interception time (t ≥ 0). Returns <see cref="IFloatingPointIeee754{T}.NaN"/> if no interception is possible.
	/// </returns>
	public static T Best<T>(float projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		T[] all = All<T>(projectileSpeed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
		return all.Length == 0 ? T.NaN : all[0];
	}

	/// <summary>
	/// Computes the earliest positive interception time between a projectile and a moving target.
	/// </summary>
	/// <typeparam name="T">A floating-point numeric type (e.g., float, double) implementing <see cref="IFloatingPointIeee754{T}"/>.</typeparam>
	/// <param name="projectileDirection">The direction of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// The earliest interception time (t ≥ 0). Returns <see cref="IFloatingPointIeee754{T}.NaN"/> if no interception is possible.
	/// </returns>
	public static T Best<T>(Vector4 projectileDirection, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		T[] all = All<T>(projectileDirection, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
		return all.Length == 0 ? T.NaN : all[0];
	}

	/// <inheritdoc cref="BsEquations4D.Time{T}(float, Vector4, Vector4, Vector4, Vector4)"/>
	public static T[] All<T>(float projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T>
		=> BsEquations4D.Time<T>(projectileSpeed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);

	/// <inheritdoc cref="BsEquations4D.Time{T}(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static T[] All<T>(Vector4 projectileDirection, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T>
		=> BsEquations4D.Time<T>(projectileDirection, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
}
