# Ballistic Solutions (GDScript)

---

## Table of Contents

1. [Installation & Dependencies](#installation)
2. [Example](#example)
3. [Reference](#reference)

---

## <a name="installation"></a>Installation & Dependencies

### Installation
1. Just download the addon from the [Asset Library](https://godotengine.org/asset-library/asset/3010) or from GitHub (all dependencies are already included).

---

### Dependencies
- [RES – Real Equation Solver](https://github.com/neclor/godot-real-equation-solver)  
  - GitHub: https://github.com/neclor/godot-real-equation-solver  
  - Asset Library: https://godotengine.org/asset-library/asset/2998

---

## <a name="example"></a>Example
```gdscript
# ...

@export var projectile_packed_scene: PackedScene

@export var projectile_speed: float = 200
@export var projectile_acceleration: Vector2 = Vector2.ZERO

func shoot(target: Target2D) -> void:
	var to_target: Vector2 = target.global_position - global_position
	var velocity: Vector2 = Bsc.best_firing_velocity_vector2(projectile_speed, to_target, target.velocity, projectile_acceleration, target.acceleration)
	
	if is_nan(velocity.x):
		print("Impossible to hit the target")
		return
	
	var new_projectile: Projectile2D = projectile_packed_scene.instantiate()
	new_projectile.global_position = global_position
	new_projectile.velocity = velocity
	new_projectile.acceleration = projectile_acceleration

	get_parent().add_child(new_projectile)

func get_best_impact_time(target: Target2D) -> float:
	var to_target: Vector2 = target.global_position - global_position
	var best_impact_time: float = Bsc.best_impact_time(projectile_speed, to_target, target.velocity, projectile_acceleration, target.acceleration)
	return best_impact_time

func get_best_impact_position(target: Target2D) -> Vector2:
	var to_target: Vector2 = target.global_position - global_position
	var best_impact_position: Vector2 = global_position + Bsc.best_impact_position(projectile_speed, to_target, target.velocity, projectile_acceleration, target.acceleration)
	return best_impact_position
```

---

## <a name="reference"></a>Reference
1. [Bsc](#bsc)
	1. [Time](#time)
	2. [Position](#position)
	3. [Velocity](#velocity)

### <a name="bsc"></a>Class: `Bsc`

#### <a name="time"></a>Methods: Time

Computes the earliest positive interception time between a projectile and a moving target.  
**Returns:** The earliest interception time (t > 0). Returns `NAN` if no interception is possible.  
Supports `Variant`, `Vector2`, `Vector3`, `Vector4` overloads.
```gdscript
float best_impact_time(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) static
```

Computes all possible interception times between a projectile and a moving target.  
**Returns:** A sorted array of all valid interception times (t > 0). Empty if interception is impossible.  
Supports `Variant`, `Vector2`, `Vector3`, `Vector4` overloads.
```gdscript
Array[float] impact_times(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) static
```

#### <a name="position"></a>Methods: Position

Computes displacement under constant acceleration.  
**Returns:** The displacement vector after `time` has elapsed.  
Supports `Variant`, `Vector2`, `Vector3`, `Vector4` overloads.
```gdscript
Variant displacement(time: float, velocity: Variant, acceleration: Variant = Vector4.ZERO) static
```

Computes the impact position of the earliest valid interception.  
**Returns:** The impact position vector. Returns `NAN` vector if interception is impossible.  
Supports `Variant`, `Vector2`, `Vector3`, `Vector4` overloads.
```gdscript
Variant best_impact_position(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) static
```

Computes all possible impact positions corresponding to valid interception times.  
**Returns:** An array of vectors representing all valid impact positions. Empty if interception is impossible.  
Supports `Variant`, `Vector2`, `Vector3`, `Vector4` overloads.
```gdscript
Array impact_positions(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) static
```

#### <a name="velocity"></a>Methods: Velocity

Computes the firing velocity required to hit the target at a given interception time.  
**Returns:** The required firing velocity vector. Returns `NAN` vector if `impact_time` ≤ 0.  
Supports `Variant`, `Vector2`, `Vector3`, `Vector4` overloads.
```gdscript
Variant firing_velocity(impact_time: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) static
```

Computes the firing velocity required for the earliest valid interception.  
**Returns:** The required firing velocity vector. Returns `NAN` vector if interception is impossible.  
Supports `Variant`, `Vector2`, `Vector3`, `Vector4` overloads.
```gdscript
Variant best_firing_velocity(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) static
```

Computes firing velocities for all valid interception times.  
**Returns:** An array of firing velocity vectors, one for each valid interception time. Empty if interception is impossible.  
Supports `Variant`, `Vector2`, `Vector3`, `Vector4` overloads.
```gdscript
Array firing_velocities(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) static
```

---
