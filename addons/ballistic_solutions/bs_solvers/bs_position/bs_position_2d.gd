@abstract class_name BsPosition2D extends BsPosition


## See [BsPosition].


## See [method BsEquations4D.displacement].
static func displacement(time: float, velocity: Vector2, acceleration: Vector2 = Vector2.ZERO) -> Vector2:
	return BsVector4Extensions.to_vector2(BsPosition4D.displacement(time, BsVector2Extensions.to_vector4(velocity), BsVector2Extensions.to_vector4(acceleration)))


## See [method BsEquations4D.position].
static func position(position: Vector2, time: float, velocity: Vector2, acceleration: Vector2 = Vector2.ZERO) -> Vector2:
	return BsVector4Extensions.to_vector2(BsPosition4D.position(BsVector2Extensions.to_vector4(position), time, BsVector2Extensions.to_vector4(velocity), BsVector2Extensions.to_vector4(acceleration)))


## See [method BsPosition4D.best_by_speed].
static func best_by_speed(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Vector2:
	return BsVector4Extensions.to_vector2(BsPosition4D.best_by_speed(projectile_speed, BsVector2Extensions.to_vector4(to_target), BsVector2Extensions.to_vector4(target_velocity), BsVector2Extensions.to_vector4(projectile_acceleration), BsVector2Extensions.to_vector4(target_acceleration)))


## See [method BsPosition4D.best_by_direction].
static func best_by_direction(projectile_direction: Vector2, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Vector2:
	return BsVector4Extensions.to_vector2(BsPosition4D.best_by_direction(BsVector2Extensions.to_vector4(projectile_direction), BsVector2Extensions.to_vector4(to_target), BsVector2Extensions.to_vector4(target_velocity), BsVector2Extensions.to_vector4(projectile_acceleration), BsVector2Extensions.to_vector4(target_acceleration)))


## See [method BsPosition4D.all_by_speed].
static func all_by_speed(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Array[Vector2]:
	var results: Array[Vector2] = []
	for p: Vector4 in BsPosition4D.all_by_speed(projectile_speed, BsVector2Extensions.to_vector4(to_target), BsVector2Extensions.to_vector4(target_velocity), BsVector2Extensions.to_vector4(projectile_acceleration), BsVector2Extensions.to_vector4(target_acceleration)):
		results.append(BsVector4Extensions.to_vector2(p))
	return results


## See [method BsPosition4D.all_by_direction].
static func all_by_direction(projectile_direction: Vector2, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) -> Array[Vector2]:
	var results: Array[Vector2] = []
	for p: Vector4 in BsPosition4D.all_by_direction(BsVector2Extensions.to_vector4(projectile_direction), BsVector2Extensions.to_vector4(to_target), BsVector2Extensions.to_vector4(target_velocity), BsVector2Extensions.to_vector4(projectile_acceleration), BsVector2Extensions.to_vector4(target_acceleration)):
		results.append(BsVector4Extensions.to_vector2(p))
	return results
