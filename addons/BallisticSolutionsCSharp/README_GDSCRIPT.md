# Ballistic Solutions (GDScript)

---

## Table of Content

1. [Dependencies](#installation)
2. [Example](#example)
3. [Reference](#reference)

---

## Dependencies
- [Real Equation Solver](https://github.com/neclor/godot-real-equation-solver) (Already included)

---

## Example
```gdscript
# ...

@export var projectile_packed_scene: PackedScene

@export var projectile_speed: float = 200
@export var projectile_acceleration: Vector2 = Vector2.ZERO

func shoot(target: Target2D) -> void:
	var to_target: Vector2 = target.global_position - global_position
	var velocity: Vector2 = BsVelocity.best_firing_velocity_by_speed_vector2(projectile_speed, to_target, target.velocity, projectile_acceleration, target.acceleration)
	
	if is_nan(velocity.x):
		print("Impossible to hit the target")
		return
	
	var new_projectile: Projectile2D = projectile_packed_scene.instantiate()
	new_projectile.global_position = global_position
	new_projectile.velocity = velocity
	new_projectile.acceleration = projectile_acceleration

	get_parent().add_child(new_projectile)
```

---

## Reference

This provides a **concise reference**, for the complete documentation, please refer to the **built-in Godot documentation**.  

Not all classes and methods are listed.  
Only semantically distinct functionality is documented.  
Overloads for `Vector2`, `Vector3`, and `Vector4` are not duplicated.  
All vector parameters are of the same dimensionality.

1. `BallisticSolutions`
	1. [`BsPosition`](#bsposition)
	2. [`BsTime`](#bstime)
	3. [`BsVelocity`](#bsvelocity)

---

## `BsPosition`

```gdscript
Array all_impact_positions_by_direction(projectile_direction, to_target, projectile_acceleration = Vector.ZERO, target_velocity = Vector.ZERO, target_acceleration = Vector.ZERO) static
```
Computes all possible impact positions corresponding to valid interception times.  
**Returns:** An array of vectors representing all valid impact positions.

---

```gdscript
Array all_impact_positions_by_speed(projectile_speed, to_target, projectile_acceleration = Vector.ZERO, target_velocity = Vector.ZERO, target_acceleration = Vector.ZERO) static
```
Computes all possible impact positions corresponding to valid interception times.  
**Returns:** An array of vectors representing all valid impact positions.

---

```gdscript
Array best_impact_position_by_direction(projectile_direction, to_target, projectile_acceleration = Vector.ZERO, target_velocity = Vector.ZERO, target_acceleration = Vector.ZERO) static
```
Computes the impact position of the earliest valid interception.  
**Returns:** The impact position vector. Returns `NAN` vector if interception is impossible.

---

```gdscript
Array best_impact_position_by_speed(projectile_speed, to_target, projectile_acceleration = Vector.ZERO, target_velocity = Vector.ZERO, target_acceleration = Vector.ZERO) static
```
Computes all possible impact positions corresponding to valid interception times.  
**Returns:** The impact position vector. Returns `NAN` vector if interception is impossible.

---

```gdscript
Vector displacement(time, velocity, acceleration = Vector.ZERO) static
```
Computes displacement under constant acceleration.  
**Returns:** The displacement vector after `time` has elapsed.

---

```gdscript
Vector position(position, time, velocity, acceleration = Vector.ZERO) static
```
Computes position after elapsed time under constant acceleration.  
**Returns:** The position vector after `time` has elapsed.

---

## `BsTime`

```gdscript
Array[float] all_impact_times_by_direction(projectile_direction, to_target, projectile_acceleration = Vector.ZERO, target_velocity = Vector.ZERO, target_acceleration = Vector.ZERO) static
```
Computes all possible interception times between a projectile and a moving target.  
**Returns:** A sorted array of all valid interception times (t > 0). Empty if interception is impossible.

---

```gdscript
Array[float] all_impact_times_by_speed(projectile_speed, to_target, projectile_acceleration = Vector.ZERO, target_velocity = Vector.ZERO, target_acceleration = Vector.ZERO) static
```
Computes all possible interception times between a projectile and a moving target.  
**Returns:** A sorted array of all valid interception times (t > 0). Empty if interception is impossible.

---

```gdscript
float best_impact_time_by_direction(projectile_direction, to_target, projectile_acceleration = Vector.ZERO, target_velocity = Vector.ZERO, target_acceleration = Vector.ZERO) static
```
Computes the earliest positive interception time between a projectile and a moving target.  
**Returns:** The earliest interception time (t > 0). Returns `NAN` if no interception is possible.

---

```gdscript
float best_impact_time_by_speed(projectile_speed, to_target, projectile_acceleration = Vector.ZERO, target_velocity = Vector.ZERO, target_acceleration = Vector.ZERO) static
```
Computes the earliest positive interception time between a projectile and a moving target.  
**Returns:** The earliest interception time (t > 0). Returns `NAN` if no interception is possible.

---

## `BsVelocity`


```gdscript
Array all_firing_velocities_by_direction(projectile_direction, to_target, projectile_acceleration = Vector.ZERO, target_velocity = Vector.ZERO, target_acceleration = Vector.ZERO) static
```
Computes firing velocities for all valid interception times.  
**Returns:** An array of firing velocity vectors, one for each valid interception time.

---

```gdscript
Array all_firing_velocities_by_speed(projectile_speed, to_target, projectile_acceleration = Vector.ZERO, target_velocity = Vector.ZERO, target_acceleration = Vector.ZERO) static
```
Computes firing velocities for all valid interception times.  
**Returns:** An array of firing velocity vectors, one for each valid interception time.

---

```gdscript
Array best_firing_velocity_by_direction(projectile_direction, to_target, projectile_acceleration = Vector.ZERO, target_velocity = Vector.ZERO, target_acceleration = Vector.ZERO) static
```
Computes the firing velocity required for the earliest valid interception.  
**Returns:** The required firing velocity vector. Returns `NAN` vector if interception is impossible.

---

```gdscript
Array best_firing_velocity_by_speed(projectile_speed, to_target, projectile_acceleration = Vector.ZERO, target_velocity = Vector.ZERO, target_acceleration = Vector.ZERO) static
```
Computes the firing velocity required for the earliest valid interception.  
**Returns:** The required firing velocity vector. Returns `NAN` vector if interception is impossible.

---

```gdscript
Vector firing_velocity(impact_time, to_target, projectile_acceleration = Vector.ZERO, target_velocity = Vector.ZERO, target_acceleration = Vector.ZERO) static
```
Computes the firing velocity required to hit the target at a given interception time.  
**Returns:** The required firing velocity vector. Returns `NAN` vector if `impact_time` ≤ 0.
