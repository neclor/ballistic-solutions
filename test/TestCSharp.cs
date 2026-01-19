using Godot;

namespace BallisticSolutions.Test;

[Tool]
public partial class TestCSharp : EditorScript {


	public override void _Run() {

		int projectileSpeed = 10;
		Vector2 toTarget = new(12, 9);
		Vector2 targetVelocity = new(-1, 2);
		Vector2 projectileAcceleration = new(1, 0);
		Vector2 targetAcceleration = new(0, -1);

		Vector2[] velocities = BsVelocity.AllFiringVelocities<float>(projectileSpeed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);

		GD.Print("Firing velocities: ", velocities.Join());
		GD.Print();

		foreach (Vector2 v in velocities) {
			GD.Print(v);
			GD.Print("Velocities: " + BsVelocity.AllFiringVelocities(v, toTarget, targetVelocity, projectileAcceleration, targetAcceleration).Join());
			GD.Print();

			Vector2 normalized = v.Normalized();
			GD.Print(normalized);
			GD.Print("Velocities: " + BsVelocity.AllFiringVelocities(normalized, toTarget, targetVelocity, projectileAcceleration, targetAcceleration).Join());
			GD.Print();
		}

		Vector2 projectileDirection = new Vector2(0, -1);
		toTarget = new Vector2(-10, -10);
		targetVelocity = new Vector2(10, 0);
		projectileAcceleration = Vector2.Zero;
		targetAcceleration = Vector2.Zero;

		GD.Print("Velocities: " + BsVelocity.AllFiringVelocities(projectileDirection, toTarget, targetVelocity, projectileAcceleration, targetAcceleration).Join());

		GD.Print();

		projectileDirection = new Vector2(1, -1);
		toTarget = new Vector2(-10, -10);
		targetVelocity = new Vector2(10, 0);
		projectileAcceleration = Vector2.Zero;
		targetAcceleration = Vector2.Zero;

		GD.Print("Times: " + BsTime.AllImpactTimes<float>(projectileDirection, toTarget, targetVelocity, projectileAcceleration, targetAcceleration).Join());
		GD.Print("Velocities: " + BsVelocity.AllFiringVelocities(projectileDirection, toTarget, targetVelocity, projectileAcceleration, targetAcceleration).Join());
	}
}
