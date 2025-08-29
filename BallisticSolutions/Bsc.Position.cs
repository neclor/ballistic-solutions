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
	/// Computes displacement under constant acceleration.
	/// </summary>
	/// <typeparam name="T">A floating-point numeric type (e.g., float, double) implementing <see cref="IFloatingPointIeee754{T}"/>.</typeparam>
	/// <param name="time">Elapsed time.</param>
	/// <param name="velocity">Initial velocity vector.</param>
	/// <param name="acceleration">Constant acceleration vector.</param>
	/// <returns>
	/// The displacement vector after <paramref name="time"/> has elapsed.
	/// </returns>
	public static Vector4 Position<T>(T time, Vector4 velocity, Vector4 acceleration) where T : IFloatingPointIeee754<T> {
		float timeFloat = float.CreateSaturating(time);
		return timeFloat * (velocity + acceleration * timeFloat / 2);
	}

	/// <inheritdoc cref="Position{T}(T, Vector4, Vector4)"/>
	public static Vector3 Position<T>(T time, Vector3 velocity, Vector3 acceleration) where T : IFloatingPointIeee754<T> {
		return Position(time, velocity.ToVector4(), acceleration.ToVector4()).ToVector3();
	}

	/// <inheritdoc cref="Position{T}(T, Vector4, Vector4)"/>
	public static Vector2 Position<T>(T time, Vector2 velocity, Vector2 acceleration) where T : IFloatingPointIeee754<T> {
		return Position(time, velocity.ToVector4(), acceleration.ToVector4()).ToVector2();
	}

	/// <summary>
	/// Computes the impact position of the earliest valid interception.
	/// </summary>
	/// <typeparam name="T">A floating-point numeric type (e.g., float, double) implementing <see cref="IFloatingPointIeee754{T}"/>.</typeparam>
	/// <param name="projectileSpeed">The speed of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// The impact position vector. Returns Vector.NaN if interception is impossible.
	/// </returns>
	public static Vector4 BestImpactPosition<T>(T projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		if (projectileSpeed < T.Zero) Warning("`Bsc.BestImpactPosition`: Negative `projectileSpeed`.");

		Vector4[] impactPositions = ImpactPositions(projectileSpeed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
		if (impactPositions.Length == 0) return Vector4.NaN;

		return impactPositions[0];
	}

	/// <inheritdoc cref="BestImpactPosition{T}(T, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector3 BestImpactPosition<T>(T projectileSpeed, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		return BestImpactPosition(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).ToVector3();
	}

	/// <inheritdoc cref="BestImpactPosition{T}(T, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector2 BestImpactPosition<T>(T projectileSpeed, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		return BestImpactPosition(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).ToVector2();
	}

	/// <summary>
	/// Computes all possible impact positions corresponding to valid interception times.
	/// </summary>
	/// <typeparam name="T">A floating-point numeric type (e.g., float, double) implementing <see cref="IFloatingPointIeee754{T}"/>.</typeparam>
	/// <param name="projectileSpeed">The speed of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// An array of vectors representing all valid impact positions.
	/// </returns>
	public static Vector4[] ImpactPositions<T>(T projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		if (projectileSpeed < T.Zero) Warning("`Bsc.ImpactPositions`: Negative `projectileSpeed`.");

		return ImpactTimes(projectileSpeed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration)
			.Select((T impactTime) => toTarget + Position(impactTime, targetVelocity, targetAcceleration))
			.ToArray();
	}

	/// <inheritdoc cref="ImpactPositions{T}(T, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector3[] ImpactPositions<T>(T projectileSpeed, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		return ImpactPositions(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4())
			.Select((Vector4 position) => position.ToVector3())
			.ToArray();
	}

	/// <inheritdoc cref="ImpactPositions{T}(T, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector2[] ImpactPositions<T>(T projectileSpeed, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		return ImpactPositions(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4())
			.Select((Vector4 position) => position.ToVector2())
			.ToArray();
	}
}
