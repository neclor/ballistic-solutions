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
/// Provides ballistic equations.
/// </summary>
public static class BsEquations {

	/// <summary>
	/// Computes displacement under constant acceleration.
	/// </summary>
	/// <typeparam name="T">A floating-point numeric type (e.g., float, double) implementing <see cref="IFloatingPointIeee754{T}"/>.</typeparam>
	/// <param name="time">Elapsed time.</param>
	/// <param name="velocity">Initial velocity vector.</param>
	/// <param name="acceleration">Constant acceleration vector.</param>
	/// <returns>
	/// The displacement vector after <paramref name="time"/> has elapsed.
	/// </returns>
	public static Vector4 Displacement<T>(T time, Vector4 velocity, Vector4 acceleration = default) where T : IFloatingPointIeee754<T> {
		float timeFloat = float.CreateSaturating(time);
		return timeFloat * (velocity + acceleration * timeFloat / 2);
	}

	/// <summary>
	/// Computes position after elapsed time under constant acceleration.
	/// </summary>
	/// <typeparam name="T">A floating-point numeric type (e.g., float, double) implementing <see cref="IFloatingPointIeee754{T}"/>.</typeparam>
	/// <param name="position">Initial position vector.</param>
	/// <param name="time">Elapsed time.</param>
	/// <param name="velocity">Initial velocity vector.</param>
	/// <param name="acceleration">Constant acceleration vector.</param>
	/// <returns>
	/// The position vector after <paramref name="time"/> has elapsed.
	/// </returns>
	public static Vector4 Position<T>(Vector4 position, T time, Vector4 velocity = default, Vector4 acceleration = default) where T : IFloatingPointIeee754<T> => position + Displacement(time, velocity, acceleration);

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
	public static T[] Time<T>(Vector4 projectileDirection, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		projectileDirection = projectileDirection.Normalized();

		Vector4 relativeAcceleration = projectileAcceleration - targetAcceleration;

		Vector4 p = relativeAcceleration - projectileDirection.Dot(relativeAcceleration) * projectileDirection;
		Vector4 q = targetVelocity - projectileDirection.Dot(targetVelocity) * projectileDirection;
		Vector4 r = toTarget - projectileDirection.Dot(toTarget) * projectileDirection;

		T a = T.CreateSaturating(p.LengthSquared() / 4);
		T b = T.CreateSaturating(-p.Dot(q));
		T c = T.CreateSaturating(q.LengthSquared() - p.Dot(r));
		T d = T.CreateSaturating(2 * q.Dot(r));
		T e = T.CreateSaturating(r.LengthSquared());

		return [.. RealQuarticEquationSolver.Solve(a, b, c, d, e).Where(i => i > T.Zero).Order()];
	}

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
	public static T[] Time<T>(T projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		if (projectileSpeed < T.Zero) Logger.FormatWarning(nameof(BsEquations), nameof(Time), "Negative `projectileSpeed`");

		Vector4 relativeAcceleration = projectileAcceleration - targetAcceleration;

		T a = T.CreateSaturating(relativeAcceleration.LengthSquared() / 4);
		T b = T.CreateSaturating(-relativeAcceleration.Dot(targetVelocity));
		T c = T.CreateSaturating(targetVelocity.LengthSquared() - relativeAcceleration.Dot(toTarget)) - projectileSpeed * projectileSpeed;
		T d = T.CreateSaturating(2 * targetVelocity.Dot(toTarget));
		T e = T.CreateSaturating(toTarget.LengthSquared());

		return [.. RealQuarticEquationSolver.Solve(a, b, c, d, e).Where(i => i > T.Zero).Order()];
	}

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
	public static Vector4 Velocity<T>(T impactTime, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		if (impactTime <= T.Zero) {
			Logger.FormatError(nameof(BsEquations), nameof(Velocity), "Zero or negative `impactTime`", "NaN vector");
			return Vector4.NaN;
		}
		float impactTimeFloat = float.CreateSaturating(impactTime);
		return toTarget / impactTimeFloat + targetVelocity - (projectileAcceleration - targetAcceleration) * impactTimeFloat / 2;
	}
}
