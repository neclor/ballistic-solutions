using Godot;

namespace BallisticSolutions.Demo.Demo2D;

[GlobalClass]
public partial class Turret2DCSharp : Node2D {

	[Export]
	public PackedScene? ProjectilePackedScene { get; set; }
	[Export]
	public CharacterBody2D? Player { get; set; }

	[Export]
	public Polygon2D? Crosshair1 { get; set; }
	[Export]
	public Polygon2D? Crosshair2 { get; set; }

	public float ProjectileSpeed { get; set; } = 200;
	public Vector2 ProjectileAcceleration { get; set; } = Vector2.Zero;

	private float[] ImpactTimes { get; set; } = [];
	private Vector2 ToTarget { get; set; }
	private Vector2 TargetVelocity { get; set; }
	private Vector2 TargetAcceleration { get; set; }

	public override void _PhysicsProcess(double delta) {
		if (Player is null) return;

		ToTarget = Player.GlobalPosition - GlobalPosition;
		TargetVelocity = Player.Velocity;
		TargetAcceleration = (Vector2)Player.Get("current_acceleration");

		ImpactTimes = Bsc.ImpactTimes(ProjectileSpeed, ToTarget, TargetVelocity, ProjectileAcceleration, TargetAcceleration);

		switch (ImpactTimes.Length) {
			case 0:
				Crosshair1?.Position = Vector2.Zero;
				Crosshair2?.Position = Vector2.Zero;
				break;

			case 1:
				Crosshair1?.Position = ToTarget + Bsc.Displacement(ImpactTimes[0], TargetVelocity, TargetAcceleration);
				Crosshair2?.Position = Vector2.Zero;
				break;

			case 2:
				Crosshair1?.Position = ToTarget + Bsc.Displacement(ImpactTimes[0], TargetVelocity, TargetAcceleration);
				Crosshair2?.Position = ToTarget + Bsc.Displacement(ImpactTimes[1], TargetVelocity, TargetAcceleration);
				break;

			default:
				break;
		}
	}

	public void CreateProjectiles() {
		if (Player is null) return;

		foreach (float time in ImpactTimes) {
			CreateProjectile(Bsc.FiringVelocity(time, ToTarget, TargetVelocity, ProjectileAcceleration, TargetAcceleration));
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

	public void OnTimerTimeout() => CreateProjectiles();
}
