using BallisticSolutions.BsSolvers.BsVelocity;
using Godot;

namespace BallisticSolutions.Demo.Demo3D;

[GlobalClass]
public partial class NewTurret3D : Node3D {
	[Export]
	private PackedScene? _bullet3D;

	[Export]
	private float _bulletSpeed = 50;

	public RigidBody3D? Target { get; set; }

	public void ChangeTarget(RigidBody3D? target) => Target = target;

	private void Shoot() {
		if (_bullet3D is null) return;
		if (Target is null) return;

		float gravity = (float)ProjectSettings.GetSetting("physics/3d/default_gravity");
		Vector3 gravityDir = (Vector3)ProjectSettings.GetSetting("physics/3d/default_gravity_vector");
		Vector3 gravityVector = gravityDir * gravity;

		Vector3[] velocities = BsVelocity3D.All(
			_bulletSpeed,
			Target.GlobalPosition - GlobalPosition,
			Target.LinearVelocity,
			gravityVector,
			gravityVector * Target.GetGravityScale()
		);

		foreach (Vector3 vel in velocities) {
			RigidBody3D bullet = _bullet3D.Instantiate<RigidBody3D>();
			GetParent().AddChild(bullet);
			bullet.GlobalPosition = GlobalPosition;
			bullet.LinearVelocity = vel;
		}
	}

	private void OnTimerTimeout() => Shoot();
}
