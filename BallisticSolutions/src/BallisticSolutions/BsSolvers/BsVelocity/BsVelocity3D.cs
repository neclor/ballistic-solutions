using System.Numerics;
using BallisticSolutions.BsVectorExtensions;
#if GODOT
using Vector3 = Godot.Vector3;
using Vector4 = Godot.Vector4;
#else
using Vector3 = System.Numerics.Vector3;
using Vector4 = System.Numerics.Vector4;
#endif

namespace BallisticSolutions.BsSolvers.BsVelocity;

/// <inheritdoc cref="BsVelocity4D"/>
public static class BsVelocity3D {
	/// <inheritdoc cref="BsVelocity4D.Velocity{T}"/>
	public static Vector3 Velocity<T>(T time, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) where T : INumber<T>
		=> BsVelocity4D.Velocity(time, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).ToVector3();

	/// <inheritdoc cref="BsVelocity4D.Best(float, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector3 Best(float projectileSpeed, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default)
		=> BsVelocity4D.Best(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).ToVector3();

	/// <inheritdoc cref="BsVelocity4D.Best(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector3 Best(Vector3 projectileDirection, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default)
		=> BsVelocity4D.Best(projectileDirection.ToVector4(), toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).ToVector3();

	/// <inheritdoc cref="BsVelocity4D.All(float, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector3[] All(float projectileSpeed, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default)
		=> [.. BsVelocity4D.All(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).Select(v => v.ToVector3())];

	/// <inheritdoc cref="BsVelocity4D.All(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static Vector3[] All(Vector3 projectileDirection, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default)
		=> [.. BsVelocity4D.All(projectileDirection.ToVector4(), toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4()).Select(v => v.ToVector3())];
}
