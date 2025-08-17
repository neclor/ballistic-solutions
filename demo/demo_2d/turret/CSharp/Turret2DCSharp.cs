using Godot;
using BallisticDeflectionCalculator;


namespace BallisticDeflectionCalculatora.Demo.Demo2D;


[GlobalClass]
public partial class Turret2DCSharp : Node2D {
	[Export]
	public PackedScene? ProjectilePackedScene { get; set; }
	[Export]
	public CharacterBody2D? Player { get; set; }

	public float ProjectileSpeed { get; set; } = 200;
	public Vector2 ProjectileAcceleration { get; set; } = Vector2.Zero;

	public void CreateProjectiles() {
		if (Player is null) return;

		Vector2 toTarget = (Vector2)Player.Get("global_position") - GlobalPosition;
		GD.Print(toTarget);
		Vector2 targetVelocity = Player.Velocity;
		GD.Print(targetVelocity);
		Vector2 targetAcceleration = (Vector2)Player.Get("current_acceleration");
		GD.Print(targetAcceleration);

		Vector2[] projectileVelocities = Bdc.Velocities(
			ProjectileSpeed,
			toTarget,
			targetVelocity,
			ProjectileAcceleration,
			targetAcceleration
		);

		//GD.Print(string.Join(", ", projectileVelocities));
		//GD.Print(string.Join(", ", projectileVelocities.Select((Vector2 vel) => vel.Length()).ToArray()));
		//GD.Print(ProjectileSpeed);

		foreach (Vector2 projectileVelocity in projectileVelocities) {
			CreateProjectile(projectileVelocity);
		}
	}

	public void CreateProjectile(Vector2 velocity) {
		if (ProjectilePackedScene is null) return;

		CharacterBody2D newProjectile = ProjectilePackedScene.Instantiate<CharacterBody2D>();
		newProjectile.GlobalPosition = GlobalPosition;
		newProjectile.Velocity = velocity;
		newProjectile.Set("acceleration", ProjectileAcceleration);
		GetParent().AddChild(newProjectile);
	}

	public void OnTimerTimeout() {
		CreateProjectiles();
	}
}
