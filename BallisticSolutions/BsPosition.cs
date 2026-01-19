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
/// Provides methods for computing projectile positions, impact positions, and displacement calculations under constant acceleration.
/// </summary>
public static class BsPosition {

	/// <inheritdoc cref="AllImpactPositions(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector2[] AllImpactPositions(Vector2 projectileDirection, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) => [.. AllImpactPositions(projectileDirection.ToVector4(), toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).Select(p => p.ToVector2())];

	/// <inheritdoc cref="AllImpactPositions(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector3[] AllImpactPositions(Vector3 projectileDirection, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) => [.. AllImpactPositions(projectileDirection.ToVector4(), toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).Select(p => p.ToVector3())];

	/// <summary>
	/// Computes all possible impact positions corresponding to valid interception times.
	/// </summary>
	/// <param name="projectileDirection">The direction of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// An array of vectors representing all valid impact positions.
	/// </returns>
	public static Vector4[] AllImpactPositions(Vector4 projectileDirection, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) => [.. BsTime.AllImpactTimes<float>(projectileDirection, toTarget, targetVelocity, projectileAcceleration, targetAcceleration).Select(impactTime => Position(toTarget, impactTime, targetVelocity, targetAcceleration))];

	/// <inheritdoc cref="AllImpactPositions{T}(T, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector2[] AllImpactPositions<T>(T projectileSpeed, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) where T : IFloatingPointIeee754<T> => [.. AllImpactPositions(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).Select(p => p.ToVector2())];

	/// <inheritdoc cref="AllImpactPositions{T}(T, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector3[] AllImpactPositions<T>(T projectileSpeed, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) where T : IFloatingPointIeee754<T> => [.. AllImpactPositions(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).Select(p => p.ToVector3())];

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
	public static Vector4[] AllImpactPositions<T>(T projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		if (projectileSpeed < T.Zero) Logger.FormatWarning(nameof(BsPosition), nameof(AllImpactPositions), "Negative `projectileSpeed`");
		return [.. BsTime.AllImpactTimes(projectileSpeed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration).Select(impactTime => Position(toTarget, impactTime, targetVelocity, targetAcceleration))];
	}

	/// <inheritdoc cref="BestImpactPosition(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector2 BestImpactPosition(Vector2 projectileDirection, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) => BestImpactPosition(projectileDirection.ToVector4(), toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).ToVector2();

	/// <inheritdoc cref="BestImpactPosition(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector3 BestImpactPosition(Vector3 projectileDirection, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) => BestImpactPosition(projectileDirection.ToVector4(), toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).ToVector3();

	/// <summary>
	/// Computes the impact position of the earliest valid interception.
	/// </summary>
	/// <param name="projectileDirection">The direction of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// The impact position vector. Returns `NaN` vector if interception is impossible.
	/// </returns>
	public static Vector4 BestImpactPosition(Vector4 projectileDirection, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) => Position(toTarget, BsTime.BestImpactTime<float>(projectileDirection, toTarget, targetVelocity, projectileAcceleration, targetAcceleration), targetVelocity, targetAcceleration);

	/// <inheritdoc cref="BestImpactPosition{T}(T, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector3 BestImpactPosition<T>(T projectileSpeed, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) where T : IFloatingPointIeee754<T> => BestImpactPosition(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).ToVector3();

	/// <inheritdoc cref="BestImpactPosition{T}(T, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector2 BestImpactPosition<T>(T projectileSpeed, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) where T : IFloatingPointIeee754<T> => BestImpactPosition(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).ToVector2();

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
	/// The impact position vector. Returns `NaN` vector if interception is impossible.
	/// </returns>
	public static Vector4 BestImpactPosition<T>(T projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T> {
		if (projectileSpeed < T.Zero) Logger.FormatWarning(nameof(BsPosition), nameof(BestImpactPosition), "Negative `projectileSpeed`");
		return Position(toTarget, BsTime.BestImpactTime(projectileSpeed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration), targetVelocity, targetAcceleration);
	}

	/// <inheritdoc cref="Displacement{T}(T, Vector4, Vector4)"/>
	public static Vector2 Displacement<T>(T time, Vector2 velocity, Vector2 acceleration = default) where T : IFloatingPointIeee754<T> => Displacement(time, velocity.ToVector4(), acceleration.ToVector4()).ToVector2();

	/// <inheritdoc cref="Displacement{T}(T, Vector4, Vector4)"/>
	public static Vector3 Displacement<T>(T time, Vector3 velocity, Vector3 acceleration = default) where T : IFloatingPointIeee754<T> => Displacement(time, velocity.ToVector4(), acceleration.ToVector4()).ToVector3();

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
	public static Vector4 Displacement<T>(T time, Vector4 velocity, Vector4 acceleration = default) where T : IFloatingPointIeee754<T> => BsEquations.Displacement(time, velocity, acceleration);

	/// <inheritdoc cref="Position{T}(Vector4, T, Vector4, Vector4)"/>
	public static Vector2 Position<T>(Vector2 position, T time, Vector2 velocity, Vector2 acceleration = default) where T : IFloatingPointIeee754<T> => Position(position.ToVector4(), time, velocity.ToVector4(), acceleration.ToVector4()).ToVector2();

	/// <inheritdoc cref="Position{T}(Vector4, T, Vector4, Vector4)"/>
	public static Vector3 Position<T>(Vector3 position, T time, Vector3 velocity, Vector3 acceleration = default) where T : IFloatingPointIeee754<T> => Position(position.ToVector4(), time, velocity.ToVector4(), acceleration.ToVector4()).ToVector3();

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
	public static Vector4 Position<T>(Vector4 position, T time, Vector4 velocity = default, Vector4 acceleration = default) where T : IFloatingPointIeee754<T> => BsEquations.Position(position, time, velocity, acceleration);
}
