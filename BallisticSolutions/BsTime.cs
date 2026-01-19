using System.Numerics;
using BallisticSolutions.VectorExtensions;

#if GODOT
using Vector2 = Godot.Vector2;
using Vector3 = Godot.Vector3;
using Vector4 = Godot.Vector4;
#else
using Vector2 = System.Numerics.Vector2;
using Vector3 = System.Numerics.Vector3;
using Vector4 = System.Numerics.Vector4;
#endif

namespace BallisticSolutions;

/// <summary>
/// Provides methods for computing interception times between a projectile and a moving target under constant acceleration.
/// </summary>
public static class BsTime {

	/// <inheritdoc cref="AllImpactTimes{T}(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static T[] AllImpactTimes<T>(Vector2 projectileDirection, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) where T : IFloatingPointIeee754<T> => AllImpactTimes<T>(projectileDirection.ToVector4(), toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4());

	/// <inheritdoc cref="AllImpactTimes{T}(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static T[] AllImpactTimes<T>(Vector3 projectileDirection, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) where T : IFloatingPointIeee754<T> => AllImpactTimes<T>(projectileDirection.ToVector4(), toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4());

	/// <summary>
	/// Computes all possible interception times between a projectile and a moving target.
	/// </summary>
	/// <typeparam name="T">A floating-point numeric type (e.g., float, double) implementing <see cref="IFloatingPointIeee754{T}"/>.</typeparam>
	/// <param name="projectileDirection">The direction of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// A sorted array of all valid interception times (t > 0). Empty if interception is impossible.
	/// </returns>
	public static T[] AllImpactTimes<T>(Vector4 projectileDirection, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T> => BsEquations.Time<T>(projectileDirection, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);

	/// <inheritdoc cref="AllImpactTimes{T}(T, Vector4, Vector4, Vector4, Vector4)"/>
	public static T[] AllImpactTimes<T>(T projectileSpeed, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) where T : IFloatingPointIeee754<T> => AllImpactTimes(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4());

	/// <inheritdoc cref="AllImpactTimes{T}(T, Vector4, Vector4, Vector4, Vector4)"/>
	public static T[] AllImpactTimes<T>(T projectileSpeed, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) where T : IFloatingPointIeee754<T> => AllImpactTimes(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4());

	/// <summary>
	/// Computes all possible interception times between a projectile and a moving target.
	/// </summary>
	/// <typeparam name="T">A floating-point numeric type (e.g., float, double) implementing <see cref="IFloatingPointIeee754{T}"/>.</typeparam>
	/// <param name="projectileSpeed">The speed of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// A sorted array of all valid interception times (t > 0). Empty if interception is impossible.
	/// </returns>
	public static T[] AllImpactTimes<T>(T projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		if (projectileSpeed < T.Zero) Logger.FormatWarning(nameof(BsEquations), nameof(AllImpactTimes), "Negative `projectileSpeed`");
		return BsEquations.Time(projectileSpeed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
	}

	/// <inheritdoc cref="BestImpactTime{T}(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static T BestImpactTime<T>(Vector2 projectileDirection, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) where T : IFloatingPointIeee754<T> => BestImpactTime<T>(projectileDirection.ToVector4(), toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4());

	/// <inheritdoc cref="BestImpactTime{T}(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static T BestImpactTime<T>(Vector3 projectileDirection, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) where T : IFloatingPointIeee754<T> => BestImpactTime<T>(projectileDirection.ToVector4(), toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4());

	/// <summary>
	/// Computes the earliest positive interception time between a projectile and a moving target.
	/// </summary>
	/// <param name="projectileDirection">The direction of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// The earliest interception time (t > 0). Returns <see cref="float.NaN"/> if no interception is possible.
	/// </returns>
	public static T BestImpactTime<T>(Vector4 projectileDirection, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		T[] allImpactTimes = AllImpactTimes<T>(projectileDirection, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
		return allImpactTimes.Length == 0 ? T.NaN : allImpactTimes[0];
	}

	/// <inheritdoc cref="BestImpactTime{T}(T, Vector4, Vector4, Vector4, Vector4)"/>
	public static T BestImpactTime<T>(T projectileSpeed, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) where T : IFloatingPointIeee754<T> => BestImpactTime(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4());

	/// <inheritdoc cref="BestImpactTime{T}(T, Vector4, Vector4, Vector4, Vector4)"/>
	public static T BestImpactTime<T>(T projectileSpeed, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) where T : IFloatingPointIeee754<T> => BestImpactTime(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4());

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
	/// The earliest interception time (t > 0). Returns <see cref="IFloatingPointIeee754{T}.NaN"/> if no interception is possible.
	/// </returns>
	public static T BestImpactTime<T>(T projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		if (projectileSpeed < T.Zero) Logger.FormatWarning(nameof(BsTime), nameof(BestImpactTime), "Negative `projectileSpeed`");
		T[] allImpactTimes = AllImpactTimes(projectileSpeed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
		return allImpactTimes.Length == 0 ? T.NaN : allImpactTimes[0];
	}
}
