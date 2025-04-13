# Ballistic Deflection Calculator
Ballistic deflection calculator is a tool for calculating the shot vector considering speeds and accelerations for Godot.

## Methods
```gdscript
Array[float] calculate_times_to_hit_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2(0, 0), projectile_acceleration: Vector2 = Vector2(0, 0), target_acceleration: Vector2 = Vector2(0, 0))
Array[float] calculate_times_to_hit_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3(0, 0, 0), projectile_acceleration: Vector3 = Vector3(0, 0, 0), target_acceleration: Vector3 = Vector3(0, 0, 0))
Array[float] calculate_times_to_hit_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4(0, 0, 0, 0), projectile_acceleration: Vector4 = Vector4(0, 0, 0, 0), target_acceleration: Vector4 = Vector4(0, 0, 0, 0))
Array[Vector2] calculate_velocities_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2(0, 0), projectile_acceleration: Vector2 = Vector2(0, 0), target_acceleration: Vector2 = Vector2(0, 0))
Array[Vector3] calculate_velocities_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3(0, 0, 0), projectile_acceleration: Vector3 = Vector3(0, 0, 0), target_acceleration: Vector3 = Vector3(0, 0, 0))
Array[Vector4] calculate_velocities_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4(0, 0, 0, 0), projectile_acceleration: Vector4 = Vector4(0, 0, 0, 0), target_acceleration: Vector4 = Vector4(0, 0, 0, 0))
Vector2 calculate_velocity_from_time_vector2(time_to_hit: float, to_target: Vector2, target_velocity: Vector2 = Vector2(0, 0), projectile_acceleration: Vector2 = Vector2(0, 0), target_acceleration: Vector2 = Vector2(0, 0))
Vector3 calculate_velocity_from_time_vector3(time_to_hit: float, to_target: Vector3, target_velocity: Vector3 = Vector3(0, 0, 0), projectile_acceleration: Vector3 = Vector3(0, 0, 0), target_acceleration: Vector3 = Vector3(0, 0, 0))
Vector4 calculate_velocity_from_time_vector4(time_to_hit: float, to_target: Vector4, target_velocity: Vector4 = Vector4(0, 0, 0, 0), projectile_acceleration: Vector4 = Vector4(0, 0, 0, 0), target_acceleration: Vector4 = Vector4(0, 0, 0, 0))
```

## Dependencies
[RES - Real Equation Solver](https://github.com/neclor/godot-real-equation-solver)

## How it works?
[Formula](docs/Formula.md)
