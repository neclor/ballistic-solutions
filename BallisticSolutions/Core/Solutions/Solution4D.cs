#if GODOT
using System.Numerics;
using BallisticSolutions.BsVectorExtensions;
using Vector4 = Godot.Vector4;
#else
using Vector2 = System.Numerics.Vector2;
using Vector3 = System.Numerics.Vector3;
using Vector4 = System.Numerics.Vector4;
#endif

namespace BallisticSolutions;

public class Solution4D : Solution {


	public Vector4 ImpactPosition { get; init; } = Vector4.NaN;

	public Vector4 ProjectileVelocity { get; init; } = Vector4.NaN;

	public float ProjectileSpeed => ProjectileVelocity.Length();

	public Vector4 ProjectileDirection => ProjectileVelocity.Normalized();

	public Vector4 ToTarget { get; init; } = Vector4.NaN;

	public float DistanceToTarget => ToTarget.Length();

	public Vector4 DirectionToTarget => ToTarget.Normalized();

	public Vector4 TargetVelocity { get; init; } = Vector4.NaN;

	public float TargetSpeed => TargetVelocity.Length();

	public Vector4 TargetDirection => TargetVelocity.Normalized();

	public Vector4 ProjectileAcceleration { get; init; } = Vector4.NaN;

	public Vector4 TargetAcceleration { get; init; } = Vector4.NaN;


	public static Solution4D Best<T>(T projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T> {

		T time = BsTime.Best(projectileSpeed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);

		Vector4 projectileVelocity = BsVelocity.Velocity(time, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);

		Vector4 position = BsPosition.Displacement(time, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);


	}



	private Solution4D(float time, Vector4 position, Vector4 projectileVelocity, Vector4 toTarget, Vector4 targetVelocity, Vector4 projectileAcceleration, Vector4 targetAcceleration) : base(time) {
		Position = position;
		ProjectileVelocity = projectileVelocity;
		ToTarget = toTarget;
		TargetVelocity = targetVelocity;
		ProjectileAcceleration = projectileAcceleration;
		TargetAcceleration = targetAcceleration;
	}
}
