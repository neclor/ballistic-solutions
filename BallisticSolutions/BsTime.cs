using System.Numerics;
using System.Runtime.InteropServices;
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
/// Provides methods for computing interception times between a projectile and a moving target under constant acceleration.
/// </summary>
public static class BsTime {

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
		if (projectileSpeed < T.Zero) Logger.PushWarning("`BsTime.AllImpactTimes`: Negative `projectileSpeed`.");

		Vector4 relativeAcceleration = projectileAcceleration - targetAcceleration;

		T a = T.CreateSaturating(relativeAcceleration.LengthSquared() / 4);
		T b = T.CreateSaturating(-relativeAcceleration.Dot(targetVelocity));
		T c = T.CreateSaturating(targetVelocity.LengthSquared() - relativeAcceleration.Dot(toTarget)) - projectileSpeed * projectileSpeed;
		T d = T.CreateSaturating(2 * targetVelocity.Dot(toTarget));
		T e = T.CreateSaturating(toTarget.LengthSquared());

		return [.. RealQuarticEquationSolver.Solve(a, b, c, d, e).Where(i => i > T.Zero).Order()];
	}


	/// <inheritdoc cref="AllImpactTimes(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static float[] AllImpactTimes(Vector2 projectileDirection, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) => AllImpactTimes(projectileDirection.ToVector4(), toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4());

	/// <inheritdoc cref="AllImpactTimes(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static float[] AllImpactTimes(Vector3 projectileDirection, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) => AllImpactTimes(projectileDirection.ToVector4(), toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4());

	/// <summary>
	/// Computes all possible interception times between a projectile and a moving target.
	/// </summary>
	/// <param name="projectileDirection">The direction of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// A sorted array of all valid interception times (t > 0). Empty if interception is impossible.
	/// </returns>
	public static float[] AllImpactTimes(Vector4 projectileDirection, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) {
		projectileDirection = projectileDirection.Normalized();

		Vector4 relativeAcceleration = projectileAcceleration - targetAcceleration;

		Vector4 p = relativeAcceleration - projectileDirection.Dot(relativeAcceleration) * projectileDirection;
		Vector4 q = targetVelocity - projectileDirection.Dot(targetVelocity) * projectileDirection;
		Vector4 r = toTarget - projectileDirection.Dot(toTarget) * projectileDirection;

		float a = p.LengthSquared() / 4;
		float b = -p.Dot(q);
		float c = q.LengthSquared() - p.Dot(r);
		float d = 2 * q.Dot(r);
		float e = r.LengthSquared();

		return [.. RealQuarticEquationSolver.Solve(a, b, c, d, e).Where(i => i > 0).Order()];
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
		if (projectileSpeed < T.Zero) Logger.PushWarning("`BsTime.BestImpactTime`: Negative `projectileSpeed`.");

		T[] allImpactTimes = AllImpactTimes(projectileSpeed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
		return allImpactTimes.Length == 0 ? T.NaN : allImpactTimes[0];
	}

	/// <inheritdoc cref="BestImpactTime(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static float BestImpactTime(Vector2 projectileDirection, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) => BestImpactTime(projectileDirection.ToVector4(), toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4());

	/// <inheritdoc cref="BestImpactTime(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static float BestImpactTime(Vector3 projectileDirection, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) => BestImpactTime(projectileDirection.ToVector4(), toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4());

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
	public static float BestImpactTime(Vector4 projectileDirection, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) {
		float[] allImpactTimes = AllImpactTimes(projectileDirection, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
		return allImpactTimes.Length == 0 ? float.NaN : allImpactTimes[0];
	}
}
