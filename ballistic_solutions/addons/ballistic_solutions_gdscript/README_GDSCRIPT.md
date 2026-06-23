# Ballistic Solutions (GDScript)

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
@export var projectile_packed_scene: PackedScene

@export var projectile_speed: float = 200
@export var projectile_acceleration: Vector2 = Vector2.ZERO

func shoot(target: Target2D) -> void:
	var to_target: Vector2 = target.global_position - global_position
	var solution: BsSolution2D = BsSolution2D.best_by_speed(projectile_speed, to_target, target.velocity, projectile_acceleration, target.acceleration)

	if solution == null:
		print("Impossible to hit the target")
		return

	var new_projectile: Projectile2D = projectile_packed_scene.instantiate()
	new_projectile.global_position = global_position
	new_projectile.velocity = solution.projectile_velocity
	new_projectile.acceleration = projectile_acceleration
	get_parent().add_child(new_projectile)
```

---

## Reference

For the complete documentation, refer to the **built-in Godot documentation**.

`Nd` suffix denotes 2D, 3D, or 4D variants — `BsTimeNd` stands for `BsTime2D`, `BsTime3D`, and `BsTime4D`. Each variant uses the corresponding `VectorN` type (`Vector2`, `Vector3`, `Vector4`). All variants share the same API.

1. [`BsSolution`](#bssolution)
2. [`BsSolutionNd`](#bssolutionnd)
3. [`BsPositionNd`](#bspositionnd)
4. [`BsTimeNd`](#bstimend)
5. [`BsVelocityNd`](#bsvelocitynd)

---

## `BsSolution`

Abstract base class. All properties are available on `BsSolution2D`, `BsSolution3D`, and `BsSolution4D`.

| Property | Type | Description |
|---|---|---|
| `time` | `float` | Interception time. |
| `position` | `VectorN` | Impact position relative to the projectile origin. |
| `distance_to_position` | `float` | Distance to the impact position. |
| `direction_to_position` | `VectorN` | Direction to the impact position. |
| `projectile_velocity` | `VectorN` | Required firing velocity. |
| `projectile_speed` | `float` | Projectile speed. |
| `projectile_direction` | `VectorN` | Projectile direction. |
| `to_target` | `VectorN` | Vector from shooter to target at t = 0. |
| `distance_to_target` | `float` | Distance to target at t = 0. |
| `direction_to_target` | `VectorN` | Direction to target at t = 0. |
| `target_velocity` | `VectorN` | Target velocity at t = 0. |
| `target_speed` | `float` | Target speed. |
| `target_direction` | `VectorN` | Target direction. |
| `projectile_acceleration` | `VectorN` | Projectile acceleration. |
| `target_acceleration` | `VectorN` | Target acceleration. |

---

## `BsSolutionNd`

```gdscript
static func best_by_speed(projectile_speed: float, to_target: VectorN, target_velocity: VectorN = VectorN.ZERO, projectile_acceleration: VectorN = VectorN.ZERO, target_acceleration: VectorN = VectorN.ZERO) -> BsSolutionNd
```
**Returns:** the earliest valid solution. Returns `null` if interception is impossible.

---

```gdscript
static func best_by_direction(projectile_direction: VectorN, to_target: VectorN, target_velocity: VectorN = VectorN.ZERO, projectile_acceleration: VectorN = VectorN.ZERO, target_acceleration: VectorN = VectorN.ZERO) -> BsSolutionNd
```
**Returns:** the earliest valid solution. Returns `null` if interception is impossible.

---

```gdscript
static func all_by_speed(projectile_speed: float, to_target: VectorN, target_velocity: VectorN = VectorN.ZERO, projectile_acceleration: VectorN = VectorN.ZERO, target_acceleration: VectorN = VectorN.ZERO) -> Array[BsSolutionNd]
```
**Returns:** all valid solutions sorted by interception time. Empty array if impossible.

---

```gdscript
static func all_by_direction(projectile_direction: VectorN, to_target: VectorN, target_velocity: VectorN = VectorN.ZERO, projectile_acceleration: VectorN = VectorN.ZERO, target_acceleration: VectorN = VectorN.ZERO) -> Array[BsSolutionNd]
```
**Returns:** all valid solutions sorted by interception time. Empty array if impossible.

---

## `BsPositionNd`

```gdscript
static func displacement(time: float, velocity: VectorN, acceleration: VectorN = VectorN.ZERO) -> VectorN
```
**Returns:** displacement under constant acceleration.

---

```gdscript
static func position(position: VectorN, time: float, velocity: VectorN, acceleration: VectorN = VectorN.ZERO) -> VectorN
```
**Returns:** position after elapsed time under constant acceleration.

---

```gdscript
static func best_by_speed(projectile_speed: float, to_target: VectorN, target_velocity: VectorN = VectorN.ZERO, projectile_acceleration: VectorN = VectorN.ZERO, target_acceleration: VectorN = VectorN.ZERO) -> VectorN
```
**Returns:** the earliest valid impact position. Returns a NaN vector if impossible.

---

```gdscript
static func best_by_direction(projectile_direction: VectorN, to_target: VectorN, target_velocity: VectorN = VectorN.ZERO, projectile_acceleration: VectorN = VectorN.ZERO, target_acceleration: VectorN = VectorN.ZERO) -> VectorN
```
**Returns:** the earliest valid impact position. Returns a NaN vector if impossible.

---

```gdscript
static func all_by_speed(projectile_speed: float, to_target: VectorN, target_velocity: VectorN = VectorN.ZERO, projectile_acceleration: VectorN = VectorN.ZERO, target_acceleration: VectorN = VectorN.ZERO) -> Array[VectorN]
```
**Returns:** all valid impact positions. Empty array if impossible.

---

```gdscript
static func all_by_direction(projectile_direction: VectorN, to_target: VectorN, target_velocity: VectorN = VectorN.ZERO, projectile_acceleration: VectorN = VectorN.ZERO, target_acceleration: VectorN = VectorN.ZERO) -> Array[VectorN]
```
**Returns:** all valid impact positions. Empty array if impossible.

---

## `BsTimeNd`

```gdscript
static func best_by_speed(projectile_speed: float, to_target: VectorN, target_velocity: VectorN = VectorN.ZERO, projectile_acceleration: VectorN = VectorN.ZERO, target_acceleration: VectorN = VectorN.ZERO) -> float
```
**Returns:** the earliest interception time (t ≥ 0). Returns `NAN` if impossible.

---

```gdscript
static func best_by_direction(projectile_direction: VectorN, to_target: VectorN, target_velocity: VectorN = VectorN.ZERO, projectile_acceleration: VectorN = VectorN.ZERO, target_acceleration: VectorN = VectorN.ZERO) -> float
```
**Returns:** the earliest interception time (t ≥ 0). Returns `NAN` if impossible.

---

```gdscript
static func all_by_speed(projectile_speed: float, to_target: VectorN, target_velocity: VectorN = VectorN.ZERO, projectile_acceleration: VectorN = VectorN.ZERO, target_acceleration: VectorN = VectorN.ZERO) -> Array[float]
```
**Returns:** all valid interception times sorted ascending. Empty array if impossible.

---

```gdscript
static func all_by_direction(projectile_direction: VectorN, to_target: VectorN, target_velocity: VectorN = VectorN.ZERO, projectile_acceleration: VectorN = VectorN.ZERO, target_acceleration: VectorN = VectorN.ZERO) -> Array[float]
```
**Returns:** all valid interception times sorted ascending. Empty array if impossible.

---

## `BsVelocityNd`

```gdscript
static func velocity(time: float, to_target: VectorN, target_velocity: VectorN = VectorN.ZERO, projectile_acceleration: VectorN = VectorN.ZERO, target_acceleration: VectorN = VectorN.ZERO) -> VectorN
```
**Returns:** the firing velocity required to hit the target at the given time.

---

```gdscript
static func best_by_speed(projectile_speed: float, to_target: VectorN, target_velocity: VectorN = VectorN.ZERO, projectile_acceleration: VectorN = VectorN.ZERO, target_acceleration: VectorN = VectorN.ZERO) -> VectorN
```
**Returns:** the earliest valid firing velocity. Returns a NaN vector if impossible.

---

```gdscript
static func best_by_direction(projectile_direction: VectorN, to_target: VectorN, target_velocity: VectorN = VectorN.ZERO, projectile_acceleration: VectorN = VectorN.ZERO, target_acceleration: VectorN = VectorN.ZERO) -> VectorN
```
**Returns:** the earliest valid firing velocity. Returns a NaN vector if impossible.

---

```gdscript
static func all_by_speed(projectile_speed: float, to_target: VectorN, target_velocity: VectorN = VectorN.ZERO, projectile_acceleration: VectorN = VectorN.ZERO, target_acceleration: VectorN = VectorN.ZERO) -> Array[VectorN]
```
**Returns:** all valid firing velocities. Empty array if impossible.

---

```gdscript
static func all_by_direction(projectile_direction: VectorN, to_target: VectorN, target_velocity: VectorN = VectorN.ZERO, projectile_acceleration: VectorN = VectorN.ZERO, target_acceleration: VectorN = VectorN.ZERO) -> Array[VectorN]
```
**Returns:** all valid firing velocities. Empty array if impossible.
