# BDC - Ballistic Deflection Calculator
Ballistic deflection calculator is a tool for calculating the shot vector considering speeds and accelerations for Godot.


## Methods
### GDScipt
```gdscript
Array[float] times_to_hit(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) static
Array[float] times_to_hit_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) static
Array[float] times_to_hit_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) static
Array[float] times_to_hit_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) static

Array velocities(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) static
Array[Vector2] velocities_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) static
Array[Vector3] velocities_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) static
Array[Vector4] velocities_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) static

Variant velocity_from_time_to_hit(time_to_hit: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) static
Vector2 velocity_from_time_to_hit_vector2(time_to_hit: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) static
Vector3 velocity_from_time_to_hit_vector3(time_to_hit: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) static
Vector4 velocity_from_time_to_hit_vector4(time_to_hit: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) static
```

### C#
```csharp

```


## Example
### GDScipt
```gdscript
@export var projectile_packed_scene: PackedScene


var projectile_speed: float = 200
var projectile_acceleration: Vector2 = Vector2.ZERO


func shoot(target: Target2D) -> void:
	var to_target: Vector2 = target.global_position - global_position

	var projectile_velocities: Array[Vector2] = Bdc.velocities_vector2(bullet_speed, to_target, target.velocity, projectile_acceleration, target.acceleration)

	if projectile_velocities.size() == 0:
		print("impossible to hit the target")
		return

	var new_projectile: Projectile2D = projectile_packed_scene.instantiate()
	new_bullet.global_position = global_position
	new_bullet.velocity = bullet_velocities[0]

	get_parent().add_child(new_projectile)
```

### C#
```csharp

```


## Demo
You can test the addon using the included demo scene.

![Demo Screenshot](docs/screenshot.png)


## Dependencies
- **GDScript version:** 
	- [RES – Real Equation Solver (GitHub)](https://github.com/neclor/godot-real-equation-solver)
	- [RES – Real Equation Solver (Asset Library)](https://godotengine.org/asset-library/asset/2998)
- **C# version:**
	- [MathNet.Numerics](https://www.nuget.org/packages/MathNet.Numerics/)


## How it works?
[Formula](docs/Formula.md)
