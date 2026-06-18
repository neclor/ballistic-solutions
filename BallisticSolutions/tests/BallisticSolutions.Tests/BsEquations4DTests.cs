using BallisticSolutions.BsSolvers;
#if GODOT
using Vector4 = Godot.Vector4;
#else
using BallisticSolutions.BsUtils;
using Vector4 = System.Numerics.Vector4;
#endif

namespace BallisticSolutions.Tests;

#pragma warning disable CA1707
public class BsEquations4DTests {
	private const float Epsilon = 1e-5f;

	private static bool Near(float a, float b) => float.Abs(a - b) < Epsilon;

	private static bool Near(Vector4 a, Vector4 b) => Near(a.X, b.X) && Near(a.Y, b.Y) && Near(a.Z, b.Z) && Near(a.W, b.W);

	private static void AssertProjectileHitsTarget(float t, Vector4 toTarget, Vector4 targetVelocity, Vector4 projectileAcceleration, Vector4 targetAcceleration) {
		Vector4 projectileVelocity = BsEquations4D.Velocity(t, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
		Vector4 projectilePosition = BsEquations4D.Displacement(t, projectileVelocity, projectileAcceleration);
		Vector4 targetPosition = BsEquations4D.Position(toTarget, t, targetVelocity, targetAcceleration);
		Assert.True(Near(projectilePosition, targetPosition));
	}

	[Fact]
	public void Displacement() {
		Vector4 result = BsEquations4D.Displacement(2, Vector4.One, Vector4.One);
		Assert.True(Near(result, Vector4.One * 4));
	}

	[Fact]
	public void Position() {
		Vector4 result = BsEquations4D.Position(Vector4.One, 2, Vector4.One, Vector4.One);
		Assert.True(Near(result, Vector4.One * 5));
	}

	[Fact]
	public void Velocity_NegativeTime_ReturnsNaN() {
		Vector4 result = BsEquations4D.Velocity(-1, Vector4.One);
		Assert.True(float.IsNaN(result.X));
	}

	[Fact]
	public void Velocity_ZeroTimeNonZeroToTarget_ReturnsNaN() {
		Vector4 result = BsEquations4D.Velocity(0, Vector4.One);
		Assert.True(float.IsNaN(result.X));
	}

	[Fact]
	public void Velocity_ZeroTimeZeroToTarget_ReturnsZero() {
		Vector4 result = BsEquations4D.Velocity(0, Vector4.Zero);
		Assert.Equal(Vector4.Zero, result);
	}

	[Fact]
	public void Velocity() {
		Vector4 result = BsEquations4D.Velocity(2, Vector4.One * 2, Vector4.One, Vector4.One, Vector4.One);
		Assert.True(Near(result, Vector4.One * 2));
	}

	[Fact]
	public void Time_Speed_NoSolution() {
		Vector4 toTarget = new(15, 10, 0, 0);
		Vector4 targetVelocity = new(2, -1, 0, 0);
		Vector4 projectileAcceleration = new(0, -9.8f, 0, 0);
		Vector4 targetAcceleration = new(1, 0, 0, 0);
		const float Speed = 1f;

		float[] times = BsEquations4D.Time<float>(Speed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
		Assert.Empty(times);
	}

	[Fact]
	public void Time_Speed_RoundTrip_BothAccelerations() {
		Vector4 toTarget = new(15, 10, 0, 0);
		Vector4 targetVelocity = new(2, -1, 0, 0);
		Vector4 projectileAcceleration = new(0, -9.8f, 0, 0);
		Vector4 targetAcceleration = new(1, 0, 0, 0);
		const float Speed = 20f;

		float[] times = BsEquations4D.Time<float>(Speed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
		Assert.Equal(2, times.Length);

		foreach (float t in times) {
			AssertProjectileHitsTarget(t, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
		}
	}

	[Fact]
	public void Time_Direction_NoSolution() {
		Vector4 direction = new(1, 0, 0, 0);
		Vector4 toTarget = new(5, 10, 0, 0);
		Vector4 targetVelocity = new(2, -1, 0, 0);
		Vector4 projectileAcceleration = new(0, -9.8f, 0, 0);
		Vector4 targetAcceleration = new(1, 0, 0, 0);

		float[] times = BsEquations4D.Time<float>(direction, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
		Assert.Empty(times);
	}

	[Fact]
	public void Time_Direction_RoundTrip_BothAccelerations() {
		Vector4 toTarget = new(15, 10, 0, 0);
		Vector4 targetVelocity = new(2, -1, 0, 0);
		Vector4 projectileAcceleration = new(0, -9.8f, 0, 0);
		Vector4 targetAcceleration = new(1, 0, 0, 0);
		const float Speed = 20f;

		float[] knownTimes = BsEquations4D.Time<float>(Speed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
		foreach (float knownTime in knownTimes) {
			Vector4 direction = BsEquations4D.Velocity(knownTime, toTarget, targetVelocity, projectileAcceleration, targetAcceleration).Normalized();

			float[] times = BsEquations4D.Time<float>(direction, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
			Assert.NotEmpty(times);

			foreach (float t in times) {
				AssertProjectileHitsTarget(t, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
			}
		}
	}
}
#pragma warning restore CA1707
