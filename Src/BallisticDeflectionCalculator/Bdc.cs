using System.Numerics;


#if USE_GODOT
	using Vector2 = Godot.Vector2;
	using Vector3 = Godot.Vector3;
	using Vector4 = Godot.Vector4;
#else
	using Vector2 = System.Numerics.Vector2;
	using Vector3 = System.Numerics.Vector3;
	using Vector4 = System.Numerics.Vector4;
#endif


namespace BallisticDeflectionCalculator;


/// <summary>
/// Provides static methods for ballistic deflection calculations, including interception times and lead velocities
/// for projectiles targeting moving objects in 2D and 3D space. Supports scenarios with constant speed and optional
/// acceleration for both projectile and target. All methods are generic and work with floating-point types.
/// </summary>
public static class Bdc {

	#region TimesToHit
	/// <summary>
	/// Calculates the possible times at which a projectile, fired with a given speed and optional acceleration, can intercept a moving target.
	/// </summary>
	/// <typeparam name="T">A floating-point numeric type (e.g., float, double) implementing <see cref="IFloatingPoint{T}"/>.</typeparam>
	/// <param name="projectileSpeed">The speed of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// An array of positive time values (sorted ascending) representing the moments when the projectile can hit the target.
	/// If no valid interception is possible, returns an empty array.
	/// </returns>
	/// <remarks>
	/// This method solves the quartic equation for interception, accounting for both projectile and target movement and acceleration.
	/// </remarks>
	public static T[] TimesToHit<T>(
		T projectileSpeed,
		Vector2 toTarget,
		Vector2 targetVelocity = default,
		Vector2 projectileAcceleration = default,
		Vector2 targetAcceleration = default
	) where T : IFloatingPoint<T> {
		return TimesToHit(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4());
	}

	/// <summary>
	/// Calculates the possible times at which a projectile, fired with a given speed and optional acceleration, can intercept a moving target.
	/// </summary>
	/// <typeparam name="T">A floating-point numeric type (e.g., float, double) implementing <see cref="IFloatingPoint{T}"/>.</typeparam>
	/// <param name="projectileSpeed">The speed of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// An array of positive time values (sorted ascending) representing the moments when the projectile can hit the target.
	/// If no valid interception is possible, returns an empty array.
	/// </returns>
	/// <remarks>
	/// This method solves the quartic equation for interception, accounting for both projectile and target movement and acceleration.
	/// </remarks>
	public static T[] TimesToHit<T>(
		T projectileSpeed,
		Vector3 toTarget,
		Vector3 targetVelocity = default,
		Vector3 projectileAcceleration = default,
		Vector3 targetAcceleration = default
	) where T : IFloatingPoint<T> {
		return TimesToHit(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4());
	}

	/// <summary>
	/// Calculates the possible times at which a projectile, fired with a given speed and optional acceleration, can intercept a moving target.
	/// </summary>
	/// <typeparam name="T">A floating-point numeric type (e.g., float, double) implementing <see cref="IFloatingPoint{T}"/>.</typeparam>
	/// <param name="projectileSpeed">The speed of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// An array of positive time values (sorted ascending) representing the moments when the projectile can hit the target.
	/// If no valid interception is possible, returns an empty array.
	/// </returns>
	/// <remarks>
	/// This method solves the quartic equation for interception, accounting for both projectile and target movement and acceleration.
	/// </remarks>
	public static T[] TimesToHit<T>(
		T projectileSpeed,
		Vector4 toTarget,
		Vector4 targetVelocity = default,
		Vector4 projectileAcceleration = default,
		Vector4 targetAcceleration = default
	) where T : IFloatingPoint<T> {
		Vector4 relativeAcceleration = projectileAcceleration - targetAcceleration;

		float a = relativeAcceleration.LengthSquared() / 4;
		float b = -relativeAcceleration.Dot(targetVelocity);
		T c = T.CreateSaturating(targetVelocity.LengthSquared() - relativeAcceleration.Dot(toTarget)) - projectileSpeed * projectileSpeed;
		float d = 2 * targetVelocity.Dot(toTarget);
		float e = toTarget.LengthSquared();

		return RealQuarticEquationSolver.Solve(a, b, double.CreateSaturating(c), d, e)
			.Where((double root) => root > 0)
			.Select((double root) => T.CreateSaturating(root))
			.ToArray();
	}
	#endregion

	#region Velocities
	/// <summary>
	/// Calculates all possible velocity vectors for a projectile to intercept a moving target, given the projectile's speed and acceleration.
	/// </summary>
	/// <typeparam name="T">A floating-point numeric type (e.g., float, double) implementing <see cref="IFloatingPoint{T}"/>.</typeparam>
	/// <param name="projectileSpeed">The speed of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// An array of velocity vectors (sorted by time to hit) that allow the projectile to intercept the target.
	/// If interception is not possible, returns an empty array.
	/// </returns>
	/// <remarks>
	/// This method computes all valid lead velocities by first determining possible interception times and then calculating the corresponding velocity vectors.
	/// </remarks>
	public static Vector2[] Velocities<T>(
		T projectileSpeed,
		Vector2 toTarget,
		Vector2 targetVelocity = default,
		Vector2 projectileAcceleration = default,
		Vector2 targetAcceleration = default
	) where T : IFloatingPoint<T> {
		return Velocities(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4())
			.Select((Vector4 velocity) => velocity.ToVector2())
			.ToArray();
	}

	/// <summary>
	/// Calculates all possible velocity vectors for a projectile to intercept a moving target, given the projectile's speed and acceleration.
	/// </summary>
	/// <typeparam name="T">A floating-point numeric type (e.g., float, double) implementing <see cref="IFloatingPoint{T}"/>.</typeparam>
	/// <param name="projectileSpeed">The speed of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// An array of velocity vectors (sorted by time to hit) that allow the projectile to intercept the target.
	/// If interception is not possible, returns an empty array.
	/// </returns>
	/// <remarks>
	/// This method computes all valid lead velocities by first determining possible interception times and then calculating the corresponding velocity vectors.
	/// </remarks>
	public static Vector3[] Velocities<T>(
		T projectileSpeed,
		Vector3 toTarget,
		Vector3 targetVelocity = default,
		Vector3 projectileAcceleration = default,
		Vector3 targetAcceleration = default
	) where T : IFloatingPoint<T> {
		return Velocities(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4())
			.Select((Vector4 velocity) => velocity.ToVector3())
			.ToArray();
	}

	/// <summary>
	/// Calculates all possible velocity vectors for a projectile to intercept a moving target, given the projectile's speed and acceleration.
	/// </summary>
	/// <typeparam name="T">A floating-point numeric type (e.g., float, double) implementing <see cref="IFloatingPoint{T}"/>.</typeparam>
	/// <param name="projectileSpeed">The speed of the projectile.</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// An array of velocity vectors (sorted by time to hit) that allow the projectile to intercept the target.
	/// If interception is not possible, returns an empty array.
	/// </returns>
	/// <remarks>
	/// This method computes all valid lead velocities by first determining possible interception times and then calculating the corresponding velocity vectors.
	/// </remarks>
	public static Vector4[] Velocities<T>(
		T projectileSpeed,
		Vector4 toTarget,
		Vector4 targetVelocity = default,
		Vector4 projectileAcceleration = default,
		Vector4 targetAcceleration = default
	) where T : IFloatingPoint<T> {
		return TimesToHit(projectileSpeed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration)
			.Select((T timeToHit) => VelocityFromTimeToHit(timeToHit, toTarget, targetVelocity, projectileAcceleration, targetAcceleration))
			.ToArray();
	}
	#endregion

	#region VelocityFromTimeToHit
	/// <summary>
	/// Calculates the required velocity vector for a projectile to intercept a moving target at a specified time.
	/// </summary>
	/// <typeparam name="T">A floating-point numeric type (e.g., float, double) implementing <see cref="IFloatingPoint{T}"/>.</typeparam>
	/// <param name="timeToHit">The time until interception (must be positive).</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// The velocity vector the projectile must have to hit the target at the specified time.
	/// Returns <see cref="Vector4.Zero"/> if <paramref name="timeToHit"/> is not positive.
	/// </returns>
	/// <remarks>
	/// This method accounts for the relative acceleration between the projectile and the target, and computes the lead velocity required for interception.
	/// </remarks>
	public static Vector2 VelocityFromTimeToHit<T>(
		T timeToHit,
		Vector2 toTarget,
		Vector2 targetVelocity = default,
		Vector2 projectileAcceleration = default,
		Vector2 targetAcceleration = default
	) where T : IFloatingPoint<T> {
		return VelocityFromTimeToHit(timeToHit, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).ToVector2();
	}

	/// <summary>
	/// Calculates the required velocity vector for a projectile to intercept a moving target at a specified time.
	/// </summary>
	/// <typeparam name="T">A floating-point numeric type (e.g., float, double) implementing <see cref="IFloatingPoint{T}"/>.</typeparam>
	/// <param name="timeToHit">The time until interception (must be positive).</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// The velocity vector the projectile must have to hit the target at the specified time.
	/// Returns <see cref="Vector4.Zero"/> if <paramref name="timeToHit"/> is not positive.
	/// </returns>
	/// <remarks>
	/// This method accounts for the relative acceleration between the projectile and the target, and computes the lead velocity required for interception.
	/// </remarks>
	public static Vector3 VelocityFromTimeToHit<T>(
		T timeToHit,
		Vector3 toTarget,
		Vector3 targetVelocity = default,
		Vector3 projectileAcceleration = default,
		Vector3 targetAcceleration = default
	) where T : IFloatingPoint<T> {
		return VelocityFromTimeToHit(timeToHit, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).ToVector3();
	}

	/// <summary>
	/// Calculates the required velocity vector for a projectile to intercept a moving target at a specified time.
	/// </summary>
	/// <typeparam name="T">A floating-point numeric type (e.g., float, double) implementing <see cref="IFloatingPoint{T}"/>.</typeparam>
	/// <param name="timeToHit">The time until interception (must be positive).</param>
	/// <param name="toTarget">The vector from the shooter to the target.</param>
	/// <param name="targetVelocity">The velocity vector of the target.</param>
	/// <param name="projectileAcceleration">The acceleration vector of the projectile.</param>
	/// <param name="targetAcceleration">The acceleration vector of the target.</param>
	/// <returns>
	/// The velocity vector the projectile must have to hit the target at the specified time.
	/// Returns <see cref="Vector4.Zero"/> if <paramref name="timeToHit"/> is not positive.
	/// </returns>
	/// <remarks>
	/// This method accounts for the relative acceleration between the projectile and the target, and computes the lead velocity required for interception.
	/// </remarks>
	public static Vector4 VelocityFromTimeToHit<T>(
		T timeToHit,
		Vector4 toTarget,
		Vector4 targetVelocity = default,
		Vector4 projectileAcceleration = default,
		Vector4 targetAcceleration = default
	) where T : IFloatingPoint<T> {
		if (timeToHit <= T.CreateSaturating(0)) return Vector4.Zero;
		float timeToHitFloat = float.CreateSaturating(timeToHit);
		return toTarget / timeToHitFloat + targetVelocity - (projectileAcceleration - targetAcceleration) * timeToHitFloat / 2;
	}
	#endregion
}
