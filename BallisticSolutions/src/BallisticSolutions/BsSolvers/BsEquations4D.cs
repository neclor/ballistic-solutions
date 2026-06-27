#if GODOT
using BallisticSolutions.Godot.BsUtils;
#else
using BallisticSolutions.BsUtils;
#endif
using System.Numerics;

#if GODOT
namespace BallisticSolutions.Godot.BsSolvers;
#else
namespace BallisticSolutions.BsSolvers;
#endif

/// <summary>
/// Provides ballistic equations.
/// </summary>
public static class BsEquations4D {
	/// <summary>
	/// Computes displacement under constant acceleration.
	/// </summary>
	/// <typeparam name="T">A numeric type implementing <see cref="INumber{T}"/>.</typeparam>
	/// <param name="time">Elapsed time.</param>
	/// <param name="velocity">Initial velocity vector.</param>
	/// <param name="acceleration">Constant acceleration vector.</param>
	/// <returns>
	/// The displacement vector after <paramref name="time"/> has elapsed.
	/// </returns>
	public static Vector4 Displacement<T>(T time, Vector4 velocity, Vector4 acceleration = default) where T : INumber<T> {
		float timeFloat = float.CreateSaturating(time);
		return timeFloat * (velocity + (acceleration * timeFloat / 2));
	}

	/// <summary>
	/// Computes position after elapsed time under constant acceleration.
	/// </summary>
	/// <typeparam name="T">A numeric type implementing <see cref="INumber{T}"/>.</typeparam>
	/// <param name="position">Initial position vector.</param>
	/// <param name="time">Elapsed time.</param>
	/// <param name="velocity">Initial velocity vector.</param>
	/// <param name="acceleration">Constant acceleration vector.</param>
	/// <returns>
	/// The position vector after <paramref name="time"/> has elapsed.
	/// </returns>
	public static Vector4 Position<T>(Vector4 position, T time, Vector4 velocity, Vector4 acceleration = default) where T : INumber<T>
		=> position + Displacement(time, velocity, acceleration);

	/// <summary>
	/// Computes the firing velocity required to hit the target at a given interception time.
	/// </summary>
	/// <typeparam name="T">A numeric type implementing <see cref="INumber{T}"/>.</typeparam>
	/// <param name="time">The time until interception (must be positive).</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// The required firing velocity vector. Returns <see cref="Vector4.Zero"/> if <paramref name="time"/> is zero and <paramref name="toTarget"/> is zero.
	/// Returns a NaN vector if <paramref name="time"/> is negative, or if <paramref name="time"/> is zero and <paramref name="toTarget"/> is non-zero.
	/// </returns>
	public static Vector4 Velocity<T>(T time, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : INumber<T> {
		switch (time) {
			case < 0:
				BsLogger.Error("Negative `time`, returned NaN vector");
				return Vector4.NaN;

			case 0:
				if (toTarget == Vector4.Zero) return Vector4.Zero;

				BsLogger.Error("Zero `time` with non-zero `toTarget`, returned NaN vector");
				return Vector4.NaN;

			default:
				float timeFloat = float.CreateSaturating(time);
				return (toTarget / timeFloat) + targetVelocity - ((projectileAcceleration - targetAcceleration) * timeFloat / 2);
		}
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
	/// A sorted array of all valid interception times (t ≥ 0). Empty if interception is impossible.
	/// </returns>
	public static T[] Time<T>(float projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		if (projectileSpeed < 0) BsLogger.Error("Negative `projectileSpeed`");

		Vector4 relativeAcceleration = projectileAcceleration - targetAcceleration;

		float a = relativeAcceleration.LengthSquared() / 4;
		float b = -relativeAcceleration.Dot(targetVelocity);
		float c = targetVelocity.LengthSquared() - relativeAcceleration.Dot(toTarget) - (projectileSpeed * projectileSpeed);
		float d = 2 * targetVelocity.Dot(toTarget);
		float e = toTarget.LengthSquared();

		return [.. RealQuarticEquationSolver.Solve(a, b, c, d, e).Where(static i => i >= 0).Select(T.CreateSaturating).Distinct().Order()];
	}

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
	/// A sorted array of all valid interception times (t ≥ 0). Empty if interception is impossible.
	/// </returns>
	public static T[] Time<T>(Vector4 projectileDirection, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		projectileDirection = projectileDirection.Normalized();

		projectileDirection.Normalized();

		Vector4 relativeAcceleration = projectileAcceleration - targetAcceleration;

		Vector4 p = relativeAcceleration - (projectileDirection.Dot(relativeAcceleration) * projectileDirection);
		Vector4 q = targetVelocity - (projectileDirection.Dot(targetVelocity) * projectileDirection);
		Vector4 r = toTarget - (projectileDirection.Dot(toTarget) * projectileDirection);

		float a = p.LengthSquared() / 4;
		float b = -p.Dot(q);
		float c = q.LengthSquared() - p.Dot(r);
		float d = 2 * q.Dot(r);
		float e = r.LengthSquared();

		return [.. RealQuarticEquationSolver.Solve(a, b, c, d, e).Where(static i => i >= 0).Select(T.CreateSaturating).Distinct().Order()];
	}
}
