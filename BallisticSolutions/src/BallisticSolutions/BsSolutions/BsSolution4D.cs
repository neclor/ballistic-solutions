using System.Numerics;
using BallisticSolutions.BsSolvers.BsPosition;
using BallisticSolutions.BsSolvers.BsTime;
using BallisticSolutions.BsSolvers.BsVelocity;

namespace BallisticSolutions.BsSolutions;

/// <summary>
/// Represents a ballistic solution.
/// </summary>
public sealed class BsSolution4D<T> : BsSolution<T, Vector4> where T : IFloatingPointIeee754<T> {
	/// <inheritdoc cref="BsSolution{TTime, TVector}.DistanceToPosition"/>
	public override float DistanceToPosition => Position.Length();

	/// <inheritdoc cref="BsSolution{TTime, TVector}.DirectionToPosition"/>
	public override Vector4 DirectionToPosition => Position.Normalized();

	/// <inheritdoc cref="BsSolution{TTime, TVector}.ProjectileSpeed"/>
	public override float ProjectileSpeed => ProjectileVelocity.Length();

	/// <inheritdoc cref="BsSolution{TTime, TVector}.ProjectileDirection"/>
	public override Vector4 ProjectileDirection => ProjectileVelocity.Normalized();

	/// <inheritdoc cref="BsSolution{TTime, TVector}.DistanceToTarget"/>
	public override float DistanceToTarget => ToTarget.Length();

	/// <inheritdoc cref="BsSolution{TTime, TVector}.DirectionToTarget"/>
	public override Vector4 DirectionToTarget => ToTarget.Normalized();

	/// <inheritdoc cref="BsSolution{TTime, TVector}.TargetSpeed"/>
	public override float TargetSpeed => TargetVelocity.Length();

	/// <inheritdoc cref="BsSolution{TTime, TVector}.TargetDirection"/>
	public override Vector4 TargetDirection => TargetVelocity.Normalized();

	internal BsSolution4D(T time, Vector4 toTarget, Vector4 targetVelocity, Vector4 projectileAcceleration, Vector4 targetAcceleration) : base(
		time,
		BsPosition4D.Position(toTarget, time, targetVelocity, targetAcceleration),
		BsVelocity4D.Velocity(time, toTarget, targetVelocity, projectileAcceleration, targetAcceleration),
		toTarget,
		targetVelocity,
		projectileAcceleration,
		targetAcceleration
	) { }
}

/// <summary>
/// Provides factory methods for creating ballistic solutions.
/// </summary>
public static class BsSolution4D {
	/// <summary>
	/// Returns the solution for the earliest valid interception using projectile speed.
	/// </summary>
	/// <typeparam name="T">A floating-point numeric type (e.g., float, double) implementing <see cref="IFloatingPointIeee754{T}"/>.</typeparam>
	/// <param name="projectileSpeed">The speed of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// The earliest valid solution. Returns <c>null</c> if no interception is possible.
	/// </returns>
	public static BsSolution4D<T>? Best<T>(float projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		T time = BsTime4D.Best<T>(projectileSpeed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
		return T.IsNaN(time) ? null : new(time, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
	}

	/// <summary>
	/// Returns the solution for the earliest valid interception using projectile direction.
	/// </summary>
	/// <typeparam name="T">A floating-point numeric type (e.g., float, double) implementing <see cref="IFloatingPointIeee754{T}"/>.</typeparam>
	/// <param name="projectileDirection">The direction of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// The earliest valid solution. Returns <c>null</c> if no interception is possible.
	/// </returns>
	public static BsSolution4D<T>? Best<T>(Vector4 projectileDirection, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		T time = BsTime4D.Best<T>(projectileDirection, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
		return T.IsNaN(time) ? null : new(time, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
	}

	/// <summary>
	/// Returns all solutions using projectile speed, sorted by interception time.
	/// </summary>
	/// <typeparam name="T">A floating-point numeric type (e.g., float, double) implementing <see cref="IFloatingPointIeee754{T}"/>.</typeparam>
	/// <param name="projectileSpeed">The speed of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// All valid solutions sorted by interception time. Empty array if no interception is possible.
	/// </returns>
	public static BsSolution4D<T>[] All<T>(float projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T>
		=> [
			.. BsTime4D.All<T>(projectileSpeed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration)
				.Select(t => new BsSolution4D<T>(t, toTarget, targetVelocity, projectileAcceleration, targetAcceleration))
		];

	/// <summary>
	/// Returns all solutions using projectile direction, sorted by interception time.
	/// </summary>
	/// <typeparam name="T">A floating-point numeric type (e.g., float, double) implementing <see cref="IFloatingPointIeee754{T}"/>.</typeparam>
	/// <param name="projectileDirection">The direction of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// All valid solutions sorted by interception time. Empty array if no interception is possible.
	/// </returns>
	public static BsSolution4D<T>[] All<T>(Vector4 projectileDirection, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T>
		=> [
			.. BsTime4D.All<T>(projectileDirection, toTarget, targetVelocity, projectileAcceleration, targetAcceleration)
				.Select(t => new BsSolution4D<T>(t, toTarget, targetVelocity, projectileAcceleration, targetAcceleration))
		];
}
