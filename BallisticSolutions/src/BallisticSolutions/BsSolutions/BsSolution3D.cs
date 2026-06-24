using System.Numerics;
using BallisticSolutions.BsSolvers.BsPosition;
using BallisticSolutions.BsSolvers.BsTime;
using BallisticSolutions.BsSolvers.BsVelocity;

namespace BallisticSolutions.BsSolutions;

/// <inheritdoc cref="BsSolution4D{T}"/>
public sealed class BsSolution3D<T> : BsSolution<T, Vector3> where T : IFloatingPointIeee754<T> {
	/// <inheritdoc cref="BsSolution{TTime, TVector}.DistanceToPosition"/>
	public override float DistanceToPosition => Position.Length();

	/// <inheritdoc cref="BsSolution{TTime, TVector}.DirectionToPosition"/>
	public override Vector3 DirectionToPosition => Position.Normalized();

	/// <inheritdoc cref="BsSolution{TTime, TVector}.ProjectileSpeed"/>
	public override float ProjectileSpeed => ProjectileVelocity.Length();

	/// <inheritdoc cref="BsSolution{TTime, TVector}.ProjectileDirection"/>
	public override Vector3 ProjectileDirection => ProjectileVelocity.Normalized();

	/// <inheritdoc cref="BsSolution{TTime, TVector}.DistanceToTarget"/>
	public override float DistanceToTarget => ToTarget.Length();

	/// <inheritdoc cref="BsSolution{TTime, TVector}.DirectionToTarget"/>
	public override Vector3 DirectionToTarget => ToTarget.Normalized();

	/// <inheritdoc cref="BsSolution{TTime, TVector}.TargetSpeed"/>
	public override float TargetSpeed => TargetVelocity.Length();

	/// <inheritdoc cref="BsSolution{TTime, TVector}.TargetDirection"/>
	public override Vector3 TargetDirection => TargetVelocity.Normalized();

	internal BsSolution3D(T time, Vector3 toTarget, Vector3 targetVelocity, Vector3 projectileAcceleration, Vector3 targetAcceleration) : base(
		time,
		BsPosition3D.Position(toTarget, time, targetVelocity, targetAcceleration),
		BsVelocity3D.Velocity(time, toTarget, targetVelocity, projectileAcceleration, targetAcceleration),
		toTarget,
		targetVelocity,
		projectileAcceleration,
		targetAcceleration
	) { }
}

/// <inheritdoc cref="BsSolution4D"/>
public static class BsSolution3D {
	/// <inheritdoc cref="BsSolution4D.Best{T}(float, Vector4, Vector4, Vector4, Vector4)"/>
	public static BsSolution3D<T>? Best<T>(float projectileSpeed, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		T time = BsTime3D.Best<T>(projectileSpeed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
		return T.IsNaN(time) ? null : new(time, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
	}

	/// <inheritdoc cref="BsSolution4D.Best{T}(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static BsSolution3D<T>? Best<T>(Vector3 projectileDirection, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		T time = BsTime3D.Best<T>(projectileDirection, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
		return T.IsNaN(time) ? null : new(time, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
	}

	/// <inheritdoc cref="BsSolution4D.All{T}(float, Vector4, Vector4, Vector4, Vector4)"/>
	public static BsSolution3D<T>[] All<T>(float projectileSpeed, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) where T : IFloatingPointIeee754<T>
		=> [
			.. BsTime3D.All<T>(projectileSpeed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration)
				.Select(t => new BsSolution3D<T>(t, toTarget, targetVelocity, projectileAcceleration, targetAcceleration))
		];

	/// <inheritdoc cref="BsSolution4D.All{T}(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static BsSolution3D<T>[] All<T>(Vector3 projectileDirection, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) where T : IFloatingPointIeee754<T>
		=> [
			.. BsTime3D.All<T>(projectileDirection, toTarget, targetVelocity, projectileAcceleration, targetAcceleration)
				.Select(t => new BsSolution3D<T>(t, toTarget, targetVelocity, projectileAcceleration, targetAcceleration))
		];
}
