using System.Numerics;
using BallisticSolutions.BsVectorExtensions;

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
			Logger.PushError("`Bsc.FiringVelocity`: Zero or negative `impactTime`. Returned NaN vector.");
			return Vector4.NaN;
		}

		float impactTimeFloat = float.CreateSaturating(impactTime);
		return toTarget / impactTimeFloat + targetVelocity - (projectileAcceleration - targetAcceleration) * impactTimeFloat / 2;
	}

	/// <inheritdoc cref="FiringVelocity{T}(T, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector3 FiringVelocity<T>(T impactTime, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) where T : IFloatingPointIeee754<T> =>
		FiringVelocity(impactTime, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).ToVector3();

	/// <inheritdoc cref="FiringVelocity{T}(T, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector2 FiringVelocity<T>(T impactTime, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) where T : IFloatingPointIeee754<T> =>
		FiringVelocity(impactTime, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).ToVector2();

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
		if (projectileSpeed < T.Zero) Logger.PushWarning("`Bsc.BestFiringVelocity`: Negative `projectileSpeed`.");

		return FiringVelocity(BestImpactTime(projectileSpeed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration), toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
	}

	/// <inheritdoc cref="BestFiringVelocity{T}(T, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector3 BestFiringVelocity<T>(T projectileSpeed, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) where T : IFloatingPointIeee754<T> =>
		BestFiringVelocity(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).ToVector3();

	/// <inheritdoc cref="BestFiringVelocity{T}(T, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector2 BestFiringVelocity<T>(T projectileSpeed, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) where T : IFloatingPointIeee754<T> =>
		BestFiringVelocity(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).ToVector2();

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
	public static Vector4[] FiringVelocities<T>(T projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		if (projectileSpeed < T.Zero) Logger.PushWarning("`Bsc.FiringVelocities`: Negative `projectileSpeed`.");

		return [..
			ImpactTimes(projectileSpeed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration)
				.Select(impactTime => FiringVelocity(impactTime, toTarget, targetVelocity, projectileAcceleration, targetAcceleration))
		];
	}

	/// <inheritdoc cref="FiringVelocities{T}(T, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector3[] FiringVelocities<T>(T projectileSpeed, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) where T : IFloatingPointIeee754<T> =>
		[..
			FiringVelocities(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4())
				.Select(velocity => velocity.ToVector3())
		];

	/// <inheritdoc cref="FiringVelocities{T}(T, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector2[] FiringVelocities<T>(T projectileSpeed, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) where T : IFloatingPointIeee754<T> =>
		[..
			FiringVelocities(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4())
				.Select(velocity => velocity.ToVector2())
		];
}
