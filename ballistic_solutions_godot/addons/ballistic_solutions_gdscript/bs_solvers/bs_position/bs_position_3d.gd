@abstract class_name BsPosition3D extends BsPosition


## See [BsPosition].


## See [method BsEquations4D.displacement].
static func displacement(time: float, velocity: Vector3, acceleration: Vector3 = Vector3.ZERO) -> Vector3:
	return BsVector4Extensions.to_vector3(BsPosition4D.displacement(time, BsVector3Extensions.to_vector4(velocity), BsVector3Extensions.to_vector4(acceleration)))


## See [method BsEquations4D.position].
static func position(position: Vector3, time: float, velocity: Vector3, acceleration: Vector3 = Vector3.ZERO) -> Vector3:
	return BsVector4Extensions.to_vector3(BsPosition4D.position(BsVector3Extensions.to_vector4(position), time, BsVector3Extensions.to_vector4(velocity), BsVector3Extensions.to_vector4(acceleration)))


## See [method BsPosition4D.best_by_speed].
static func best_by_speed(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Vector3:
	return BsVector4Extensions.to_vector3(BsPosition4D.best_by_speed(projectile_speed, BsVector3Extensions.to_vector4(to_target), BsVector3Extensions.to_vector4(target_velocity), BsVector3Extensions.to_vector4(projectile_acceleration), BsVector3Extensions.to_vector4(target_acceleration)))


## See [method BsPosition4D.best_by_direction].
static func best_by_direction(projectile_direction: Vector3, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Vector3:
	return BsVector4Extensions.to_vector3(BsPosition4D.best_by_direction(BsVector3Extensions.to_vector4(projectile_direction), BsVector3Extensions.to_vector4(to_target), BsVector3Extensions.to_vector4(target_velocity), BsVector3Extensions.to_vector4(projectile_acceleration), BsVector3Extensions.to_vector4(target_acceleration)))


## See [method BsPosition4D.all_by_speed].
static func all_by_speed(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Array[Vector3]:
	var results: Array[Vector3] = []
	for p: Vector4 in BsPosition4D.all_by_speed(projectile_speed, BsVector3Extensions.to_vector4(to_target), BsVector3Extensions.to_vector4(target_velocity), BsVector3Extensions.to_vector4(projectile_acceleration), BsVector3Extensions.to_vector4(target_acceleration)):
		results.append(BsVector4Extensions.to_vector3(p))
	return results


## See [method BsPosition4D.all_by_direction].
static func all_by_direction(projectile_direction: Vector3, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) -> Array[Vector3]:
	var results: Array[Vector3] = []
	for p: Vector4 in BsPosition4D.all_by_direction(BsVector3Extensions.to_vector4(projectile_direction), BsVector3Extensions.to_vector4(to_target), BsVector3Extensions.to_vector4(target_velocity), BsVector3Extensions.to_vector4(projectile_acceleration), BsVector3Extensions.to_vector4(target_acceleration)):
		results.append(BsVector4Extensions.to_vector3(p))
	return results
