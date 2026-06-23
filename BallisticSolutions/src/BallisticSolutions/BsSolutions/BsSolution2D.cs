using System.Numerics;
using BallisticSolutions.BsSolvers.BsPosition;
using BallisticSolutions.BsSolvers.BsTime;
using BallisticSolutions.BsSolvers.BsVelocity;
#if GODOT
using Vector2 = Godot.Vector2;
using Vector4 = Godot.Vector4;
#else
using BallisticSolutions.BsUtils;
using Vector2 = System.Numerics.Vector2;
using Vector4 = System.Numerics.Vector4;
#endif

namespace BallisticSolutions.BsSolutions;

/// <inheritdoc cref="BsSolution4D{T}"/>
public sealed class BsSolution2D<T> : BsSolution<T, Vector2> where T : IFloatingPointIeee754<T> {
	/// <inheritdoc cref="BsSolution{TTime, TVector}.DistanceToPosition"/>
	public override float DistanceToPosition => Position.Length();

	/// <inheritdoc cref="BsSolution{TTime, TVector}.DirectionToPosition"/>
	public override Vector2 DirectionToPosition => Position.Normalized();

	/// <inheritdoc cref="BsSolution{TTime, TVector}.ProjectileSpeed"/>
	public override float ProjectileSpeed => ProjectileVelocity.Length();

	/// <inheritdoc cref="BsSolution{TTime, TVector}.ProjectileDirection"/>
	public override Vector2 ProjectileDirection => ProjectileVelocity.Normalized();

	/// <inheritdoc cref="BsSolution{TTime, TVector}.DistanceToTarget"/>
	public override float DistanceToTarget => ToTarget.Length();

	/// <inheritdoc cref="BsSolution{TTime, TVector}.DirectionToTarget"/>
	public override Vector2 DirectionToTarget => ToTarget.Normalized();

	/// <inheritdoc cref="BsSolution{TTime, TVector}.TargetSpeed"/>
	public override float TargetSpeed => TargetVelocity.Length();

	/// <inheritdoc cref="BsSolution{TTime, TVector}.TargetDirection"/>
	public override Vector2 TargetDirection => TargetVelocity.Normalized();

	internal BsSolution2D(T time, Vector2 toTarget, Vector2 targetVelocity, Vector2 projectileAcceleration, Vector2 targetAcceleration) : base(
		time,
		BsPosition2D.Position(toTarget, time, targetVelocity, targetAcceleration),
		BsVelocity2D.Velocity(time, toTarget, targetVelocity, projectileAcceleration, targetAcceleration),
		toTarget,
		targetVelocity,
		projectileAcceleration,
		targetAcceleration
	) { }
}

/// <inheritdoc cref="BsSolution4D"/>
public static class BsSolution2D {
	/// <inheritdoc cref="BsSolution4D.Best{T}(float, Vector4, Vector4, Vector4, Vector4)"/>
	public static BsSolution2D<T>? Best<T>(float projectileSpeed, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		T time = BsTime2D.Best<T>(projectileSpeed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
		return T.IsNaN(time) ? null : new(time, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
	}

	/// <inheritdoc cref="BsSolution4D.Best{T}(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static BsSolution2D<T>? Best<T>(Vector2 projectileDirection, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		T time = BsTime2D.Best<T>(projectileDirection, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
		return T.IsNaN(time) ? null : new(time, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
	}

	/// <inheritdoc cref="BsSolution4D.All{T}(float, Vector4, Vector4, Vector4, Vector4)"/>
	public static BsSolution2D<T>[] All<T>(float projectileSpeed, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) where T : IFloatingPointIeee754<T>
		=> [
			.. BsTime2D.All<T>(projectileSpeed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration)
				.Select(t => new BsSolution2D<T>(t, toTarget, targetVelocity, projectileAcceleration, targetAcceleration))
		];

	/// <inheritdoc cref="BsSolution4D.All{T}(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static BsSolution2D<T>[] All<T>(Vector2 projectileDirection, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) where T : IFloatingPointIeee754<T>
		=> [
			.. BsTime2D.All<T>(projectileDirection, toTarget, targetVelocity, projectileAcceleration, targetAcceleration)
				.Select(t => new BsSolution2D<T>(t, toTarget, targetVelocity, projectileAcceleration, targetAcceleration))
		];
}
