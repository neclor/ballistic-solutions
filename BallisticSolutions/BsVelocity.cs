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
/// Provides methods for computing required firing velocities to hit a target under constant acceleration conditions.
/// </summary>
public static class BsVelocity {

	/// <inheritdoc cref="AllFiringVelocities(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector2[] AllFiringVelocities(Vector2 projectileDirection, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) => [.. AllFiringVelocities(projectileDirection.ToVector4(), toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).Select(v => v.ToVector2())];

	/// <inheritdoc cref="AllFiringVelocities(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector3[] AllFiringVelocities(Vector3 projectileDirection, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) => [.. AllFiringVelocities(projectileDirection.ToVector4(), toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).Select(v => v.ToVector3())];

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
	public static Vector4[] AllFiringVelocities(Vector4 projectileDirection, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) => [.. BsTime.AllImpactTimes<float>(projectileDirection, toTarget, targetVelocity, projectileAcceleration, targetAcceleration).Select(impactTime => FiringVelocity(impactTime, toTarget, targetVelocity, projectileAcceleration, targetAcceleration))];

	/// <inheritdoc cref="AllFiringVelocities{T}(T, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector2[] AllFiringVelocities<T>(T projectileSpeed, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) where T : IFloatingPointIeee754<T> => [.. AllFiringVelocities(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).Select(velocity => velocity.ToVector2())];

	/// <inheritdoc cref="AllFiringVelocities{T}(T, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector3[] AllFiringVelocities<T>(T projectileSpeed, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) where T : IFloatingPointIeee754<T> => [.. AllFiringVelocities(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).Select(velocity => velocity.ToVector3())];

	/// <summary>
	/// Computes firing velocities for all valid interception times.
	/// </summary>
	/// <typeparam name="T">A floating-point numeric type (e.g., float, double) implementing <see cref="IFloatingPointIeee754{T}"/>.</typeparam>
	/// <param name="projectileSpeed">The speed of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// An array of firing velocity vectors, one for each valid interception time.
	/// </returns>
	public static Vector4[] AllFiringVelocities<T>(T projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		if (projectileSpeed < T.Zero) Logger.FormatWarning(nameof(BsVelocity), nameof(AllFiringVelocities), "Negative `projectileSpeed`");
		return [.. BsTime.AllImpactTimes(projectileSpeed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration).Select(impactTime => FiringVelocity(impactTime, toTarget, targetVelocity, projectileAcceleration, targetAcceleration))];
	}

	/// <inheritdoc cref="BestFiringVelocity(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector2 BestFiringVelocity(Vector2 projectileDirection, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) => BestFiringVelocity(projectileDirection.ToVector4(), toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).ToVector2();

	/// <inheritdoc cref="BestFiringVelocity(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector3 BestFiringVelocity(Vector3 projectileDirection, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) => BestFiringVelocity(projectileDirection.ToVector4(), toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).ToVector3();

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
	public static Vector4 BestFiringVelocity(Vector4 projectileDirection, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) => FiringVelocity(BsTime.BestImpactTime<float>(projectileDirection, toTarget, targetVelocity, projectileAcceleration, targetAcceleration), toTarget, targetVelocity, projectileAcceleration, targetAcceleration);

	/// <inheritdoc cref="BestFiringVelocity{T}(T, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector2 BestFiringVelocity<T>(T projectileSpeed, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) where T : IFloatingPointIeee754<T> => BestFiringVelocity(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).ToVector2();

	/// <inheritdoc cref="BestFiringVelocity{T}(T, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector3 BestFiringVelocity<T>(T projectileSpeed, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) where T : IFloatingPointIeee754<T> => BestFiringVelocity(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).ToVector3();

	/// <summary>
	/// Computes the firing velocity required for the earliest valid interception.
	/// </summary>
	/// <typeparam name="T">A floating-point numeric type (e.g., float, double) implementing <see cref="IFloatingPointIeee754{T}"/>.</typeparam>
	/// <param name="projectileSpeed">The speed of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// The required firing velocity vector. Returns `NaN` vector if interception is impossible.
	/// </returns>
	public static Vector4 BestFiringVelocity<T>(T projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		if (projectileSpeed < T.Zero) Logger.FormatWarning(nameof(BsVelocity), nameof(BestFiringVelocity), "Negative `projectileSpeed`");
		return FiringVelocity(BsTime.BestImpactTime(projectileSpeed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration), toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
	}

	/// <inheritdoc cref="FiringVelocity{T}(T, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector2 FiringVelocity<T>(T impactTime, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) where T : IFloatingPointIeee754<T> => FiringVelocity(impactTime, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).ToVector2();

	/// <inheritdoc cref="FiringVelocity{T}(T, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector3 FiringVelocity<T>(T impactTime, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) where T : IFloatingPointIeee754<T> => FiringVelocity(impactTime, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).ToVector3();

	/// <summary>
	/// Computes the firing velocity required to hit the target at a given interception time.
	/// </summary>
	/// <typeparam name="T">A floating-point numeric type (e.g., float, double) implementing <see cref="IFloatingPointIeee754{T}"/>.</typeparam>
	/// <param name="impactTime">The time until interception (must be positive).</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// The required firing velocity vector. Returns Vector.NaN if <paramref name="impactTime"/> ≤ 0.
	/// </returns>
	public static Vector4 FiringVelocity<T>(T impactTime, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		if (impactTime <= T.Zero) {
			Logger.FormatError(nameof(BsVelocity), nameof(FiringVelocity), "Zero or negative `impactTime`", "NaN vector");
			return Vector4.NaN;
		}
		float impactTimeFloat = float.CreateSaturating(impactTime);
		return toTarget / impactTimeFloat + targetVelocity - (projectileAcceleration - targetAcceleration) * impactTimeFloat / 2;
	}
}
