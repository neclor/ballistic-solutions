using System.Numerics;

namespace BallisticSolutions.BsSolutions;

/// <summary>
/// Abstract base class for typed ballistic solutions.
/// </summary>
public abstract class BsSolution<TTime, TVector> where TTime : IFloatingPointIeee754<TTime> {
	/// <summary>The interception time.</summary>
	public TTime Time { get; }

	/// <summary>The impact position relative to the projectile origin.</summary>
	public TVector Position { get; }

	/// <summary>The distance to the impact position derived from <see cref="Position"/>.</summary>
	public abstract float DistanceToPosition { get; }

	/// <summary> The direction to the impact position derived from <see cref="Position"/>.</summary>
	public abstract TVector DirectionToPosition { get; }

	/// <summary>The required firing velocity.</summary>
	public TVector ProjectileVelocity { get; }

	/// <summary>The projectile speed derived from <see cref="ProjectileVelocity"/>.</summary>
	public abstract float ProjectileSpeed { get; }

	/// <summary>The projectile direction derived from <see cref="ProjectileVelocity"/>.</summary>
	public abstract TVector ProjectileDirection { get; }

	/// <summary>The displacement from projectile origin to target at t = 0.</summary>
	public TVector ToTarget { get; }

	/// <summary>The distance to target at t = 0.</summary>
	public abstract float DistanceToTarget { get; }

	/// <summary>The direction to target at t = 0.</summary>
	public abstract TVector DirectionToTarget { get; }

	/// <summary>The target velocity at t = 0.</summary>
	public TVector TargetVelocity { get; }

	/// <summary>The target speed derived from <see cref="TargetVelocity"/>.</summary>
	public abstract float TargetSpeed { get; }

	/// <summary>The target direction derived from <see cref="TargetVelocity"/>.</summary>
	public abstract TVector TargetDirection { get; }

	/// <summary>The acceleration vector of the projectile.</summary>
	public TVector ProjectileAcceleration { get; }

	/// <summary>The acceleration vector of the target.</summary>
	public TVector TargetAcceleration { get; }

	private protected BsSolution(TTime time, TVector position, TVector projectileVelocity, TVector toTarget, TVector targetVelocity, TVector projectileAcceleration, TVector targetAcceleration) {
		Time = time;
		Position = position;
		ProjectileVelocity = projectileVelocity;
		ToTarget = toTarget;
		TargetVelocity = targetVelocity;
		ProjectileAcceleration = projectileAcceleration;
		TargetAcceleration = targetAcceleration;
	}
}
