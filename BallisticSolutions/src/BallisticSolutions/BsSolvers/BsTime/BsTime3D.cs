using System.Numerics;
using BallisticSolutions.BsVectorExtensions;
#if GODOT
using Vector3 = Godot.Vector3;
using Vector4 = Godot.Vector4;
#else
using Vector3 = System.Numerics.Vector3;
using Vector4 = System.Numerics.Vector4;
#endif

namespace BallisticSolutions.BsSolvers.BsTime;

/// <inheritdoc cref="BsTime4D"/>
public static class BsTime3D {
	/// <inheritdoc cref="BsTime4D.Best{T}(float, Vector4, Vector4, Vector4, Vector4)"/>
	public static T Best<T>(float projectileSpeed, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) where T : IFloatingPointIeee754<T>
		=> BsTime4D.Best<T>(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4());

	/// <inheritdoc cref="BsTime4D.Best{T}(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static T Best<T>(Vector3 projectileDirection, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) where T : IFloatingPointIeee754<T>
		=> BsTime4D.Best<T>(projectileDirection.ToVector4(), toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4());

	/// <inheritdoc cref="BsTime4D.All{T}(float, Vector4, Vector4, Vector4, Vector4)"/>
	public static T[] All<T>(float projectileSpeed, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) where T : IFloatingPointIeee754<T>
		=> BsTime4D.All<T>(projectileSpeed, toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4());

	/// <inheritdoc cref="BsTime4D.All{T}(Vector4, Vector4, Vector4, Vector4, Vector4)"/>
	public static T[] All<T>(Vector3 projectileDirection, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) where T : IFloatingPointIeee754<T>
		=> BsTime4D.All<T>(projectileDirection.ToVector4(), toTarget.ToVector4(), targetVelocity.ToVector4(), projectileAcceleration.ToVector4(), targetAcceleration.ToVector4());
}
