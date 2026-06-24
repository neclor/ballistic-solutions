# BallisticSolutions (GDScript)

---

## Table of Contents

1. [Dependencies](#dependencies)
2. [Example](#example)
3. [Reference](#reference)

---

## Dependencies
- [Real Equation Solver](https://github.com/neclor/godot-real-equation-solver) (Already included)

---

## Example

```gdscript
@export var projectile_scene: PackedScene

@export var projectile_speed: float = 200
@export var projectile_acceleration: Vector2 = Vector2.ZERO

func shoot(target: Target2D) -> void:
	var to_target: Vector2 = target.global_position - global_position

	var velocity: Vector2 = BsVelocity2D.best_by_speed(
		projectile_speed,
		to_target,
		target.velocity,
		projectile_acceleration,
		target.acceleration
	)

	if is_nan(velocity.x):
		print("Impossible to hit the target")
		return

	var new_projectile: Projectile2D = projectile_scene.instantiate()
	new_projectile.global_position = global_position
	new_projectile.velocity = velocity
	new_projectile.acceleration = projectile_acceleration
	get_parent().add_child(new_projectile)
```

---

## Reference

For the complete documentation, refer to the **built-in Godot documentation**.

`*D` suffix denotes 2D, 3D, or 4D variants — `BsTime*D` stands for `BsTime2D`, `BsTime3D`, and `BsTime4D`. Each variant uses the corresponding `Vector*` type (`Vector2`, `Vector3`, `Vector4`). All variants share the same API.

1. [`BsSolution`](#bssolution)
2. [`BsSolution*D`](#bssolutiond)
3. [`BsPosition*D`](#bspositiond)
4. [`BsTime*D`](#bstimed)
5. [`BsVelocity*D`](#bsvelocityd)

---

## `BsSolution`

Abstract base class. All properties are available on `BsSolution2D`, `BsSolution3D`, and `BsSolution4D`.

| Property | Type | Description |
|---|---|---|
| `time` | `float` | Interception time. |
| `position` | `Vector*` | Impact position relative to the projectile origin. |
| `distance_to_position` | `float` | Distance to the impact position. |
| `direction_to_position` | `Vector*` | Direction to the impact position. |
| `projectile_velocity` | `Vector*` | Required firing velocity. |
| `projectile_speed` | `float` | Projectile speed. |
| `projectile_direction` | `Vector*` | Projectile direction. |
| `to_target` | `Vector*` | Vector from shooter to target at t = 0. |
| `distance_to_target` | `float` | Distance to target at t = 0. |
| `direction_to_target` | `Vector*` | Direction to target at t = 0. |
| `target_velocity` | `Vector*` | Target velocity at t = 0. |
| `target_speed` | `float` | Target speed. |
| `target_direction` | `Vector*` | Target direction. |
| `projectile_acceleration` | `Vector*` | Projectile acceleration. |
| `target_acceleration` | `Vector*` | Target acceleration. |

---

## `BsSolution*D`

```gdscript
static func best_by_speed(projectile_speed: float, to_target: Vector*, target_velocity: Vector* = Vector*.ZERO, projectile_acceleration: Vector* = Vector*.ZERO, target_acceleration: Vector* = Vector*.ZERO) -> BsSolution*D
```
**Returns:** the earliest valid solution. Returns `null` if interception is impossible.

---

```gdscript
static func best_by_direction(projectile_direction: Vector*, to_target: Vector*, target_velocity: Vector* = Vector*.ZERO, projectile_acceleration: Vector* = Vector*.ZERO, target_acceleration: Vector* = Vector*.ZERO) -> BsSolution*D
```
**Returns:** the earliest valid solution. Returns `null` if interception is impossible.

---

```gdscript
static func all_by_speed(projectile_speed: float, to_target: Vector*, target_velocity: Vector* = Vector*.ZERO, projectile_acceleration: Vector* = Vector*.ZERO, target_acceleration: Vector* = Vector*.ZERO) -> Array[BsSolution*D]
```
**Returns:** all valid solutions sorted by interception time. Empty array if impossible.

---

```gdscript
static func all_by_direction(projectile_direction: Vector*, to_target: Vector*, target_velocity: Vector* = Vector*.ZERO, projectile_acceleration: Vector* = Vector*.ZERO, target_acceleration: Vector* = Vector*.ZERO) -> Array[BsSolution*D]
```
**Returns:** all valid solutions sorted by interception time. Empty array if impossible.

---

## `BsPosition*D`

```gdscript
static func displacement(time: float, velocity: Vector*, acceleration: Vector* = Vector*.ZERO) -> Vector*
```
**Returns:** displacement under constant acceleration.

---

```gdscript
static func position(position: Vector*, time: float, velocity: Vector*, acceleration: Vector* = Vector*.ZERO) -> Vector*
```
**Returns:** position after elapsed time under constant acceleration.

---

```gdscript
static func best_by_speed(projectile_speed: float, to_target: Vector*, target_velocity: Vector* = Vector*.ZERO, projectile_acceleration: Vector* = Vector*.ZERO, target_acceleration: Vector* = Vector*.ZERO) -> Vector*
```
**Returns:** the earliest valid impact position. Returns a NaN vector if impossible.

---

```gdscript
static func best_by_direction(projectile_direction: Vector*, to_target: Vector*, target_velocity: Vector* = Vector*.ZERO, projectile_acceleration: Vector* = Vector*.ZERO, target_acceleration: Vector* = Vector*.ZERO) -> Vector*
```
**Returns:** the earliest valid impact position. Returns a NaN vector if impossible.

---

```gdscript
static func all_by_speed(projectile_speed: float, to_target: Vector*, target_velocity: Vector* = Vector*.ZERO, projectile_acceleration: Vector* = Vector*.ZERO, target_acceleration: Vector* = Vector*.ZERO) -> Array[Vector*]
```
**Returns:** all valid impact positions. Empty array if impossible.

---

```gdscript
static func all_by_direction(projectile_direction: Vector*, to_target: Vector*, target_velocity: Vector* = Vector*.ZERO, projectile_acceleration: Vector* = Vector*.ZERO, target_acceleration: Vector* = Vector*.ZERO) -> Array[Vector*]
```
**Returns:** all valid impact positions. Empty array if impossible.

---

## `BsTime*D`

```gdscript
static func best_by_speed(projectile_speed: float, to_target: Vector*, target_velocity: Vector* = Vector*.ZERO, projectile_acceleration: Vector* = Vector*.ZERO, target_acceleration: Vector* = Vector*.ZERO) -> float
```
**Returns:** the earliest interception time (t ≥ 0). Returns `NAN` if impossible.

---

```gdscript
static func best_by_direction(projectile_direction: Vector*, to_target: Vector*, target_velocity: Vector* = Vector*.ZERO, projectile_acceleration: Vector* = Vector*.ZERO, target_acceleration: Vector* = Vector*.ZERO) -> float
```
**Returns:** the earliest interception time (t ≥ 0). Returns `NAN` if impossible.

---

```gdscript
static func all_by_speed(projectile_speed: float, to_target: Vector*, target_velocity: Vector* = Vector*.ZERO, projectile_acceleration: Vector* = Vector*.ZERO, target_acceleration: Vector* = Vector*.ZERO) -> Array[float]
```
**Returns:** all valid interception times sorted ascending. Empty array if impossible.

---

```gdscript
static func all_by_direction(projectile_direction: Vector*, to_target: Vector*, target_velocity: Vector* = Vector*.ZERO, projectile_acceleration: Vector* = Vector*.ZERO, target_acceleration: Vector* = Vector*.ZERO) -> Array[float]
```
**Returns:** all valid interception times sorted ascending. Empty array if impossible.

---

## `BsVelocity*D`

```gdscript
static func velocity(time: float, to_target: Vector*, target_velocity: Vector* = Vector*.ZERO, projectile_acceleration: Vector* = Vector*.ZERO, target_acceleration: Vector* = Vector*.ZERO) -> Vector*
```
**Returns:** the firing velocity required to hit the target at the given time.

---

```gdscript
static func best_by_speed(projectile_speed: float, to_target: Vector*, target_velocity: Vector* = Vector*.ZERO, projectile_acceleration: Vector* = Vector*.ZERO, target_acceleration: Vector* = Vector*.ZERO) -> Vector*
```
**Returns:** the earliest valid firing velocity. Returns a NaN vector if impossible.

---

```gdscript
static func best_by_direction(projectile_direction: Vector*, to_target: Vector*, target_velocity: Vector* = Vector*.ZERO, projectile_acceleration: Vector* = Vector*.ZERO, target_acceleration: Vector* = Vector*.ZERO) -> Vector*
```
**Returns:** the earliest valid firing velocity. Returns a NaN vector if impossible.

---

```gdscript
static func all_by_speed(projectile_speed: float, to_target: Vector*, target_velocity: Vector* = Vector*.ZERO, projectile_acceleration: Vector* = Vector*.ZERO, target_acceleration: Vector* = Vector*.ZERO) -> Array[Vector*]
```
**Returns:** all valid firing velocities. Empty array if impossible.

---

```gdscript
static func all_by_direction(projectile_direction: Vector*, to_target: Vector*, target_velocity: Vector* = Vector*.ZERO, projectile_acceleration: Vector* = Vector*.ZERO, target_acceleration: Vector* = Vector*.ZERO) -> Array[Vector*]
```
**Returns:** all valid firing velocities. Empty array if impossible.
