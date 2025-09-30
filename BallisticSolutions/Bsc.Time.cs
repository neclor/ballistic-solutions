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

public static partial class Bsc {

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
		if (projectileSpeed < T.Zero) Warning("`Bsc.BestImpactTime`: Negative `projectileSpeed`.");

		T[] impactTimes = ImpactTimes(projectileSpeed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
		if (impactTimes.Length == 0) return T.NaN;

		return impactTimes[0];
	}

	/// <inheritdoc cref="BestImpactTime{T}(T, Vector4, Vector4, Vector4, Vector4)"/>
	public static T BestImpactTime<T>(T projectileSpeed, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) where T : IFloatingPointIeee754<T> =>
		BestImpactTime(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4());

	/// <inheritdoc cref="BestImpactTime{T}(T, Vector4, Vector4, Vector4, Vector4)"/>
	public static T BestImpactTime<T>(T projectileSpeed, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) where T : IFloatingPointIeee754<T> =>
		BestImpactTime(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4());

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
	public static T[] ImpactTimes<T>(T projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		if (projectileSpeed < T.Zero) Warning("`Bsc.ImpactTimes`: Negative `projectileSpeed`.");

		Vector4 relativeAcceleration = projectileAcceleration - targetAcceleration;

		T a = T.CreateSaturating(relativeAcceleration.LengthSquared() / 4);
		T b = T.CreateSaturating(-relativeAcceleration.Dot(targetVelocity));
		T c = T.CreateSaturating(targetVelocity.LengthSquared() - relativeAcceleration.Dot(toTarget)) - projectileSpeed * projectileSpeed;
		T d = T.CreateSaturating(2 * targetVelocity.Dot(toTarget));
		T e = T.CreateSaturating(toTarget.LengthSquared());

		return [..
			RealQuarticEquationSolver.Solve(a, b, c, d, e)
				.Where(impactTime => impactTime > T.Zero)
				.OrderBy(impactTime => impactTime)
		];
	}

	/// <inheritdoc cref="ImpactTimes{T}(T, Vector4, Vector4, Vector4, Vector4)"/>
	public static T[] ImpactTimes<T>(T projectileSpeed, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) where T : IFloatingPointIeee754<T> =>
		ImpactTimes(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4());

	/// <inheritdoc cref="ImpactTimes{T}(T, Vector4, Vector4, Vector4, Vector4)"/>
	public static T[] ImpactTimes<T>(T projectileSpeed, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) where T : IFloatingPointIeee754<T> =>
		ImpactTimes(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4());
}
