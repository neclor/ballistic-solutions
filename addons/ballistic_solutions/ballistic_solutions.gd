class_name BallisticSolutions extends Object


## Library for calculating interception times, impact positions, and firing vectors, taking into account the velocities and accelerations of both projectile and target.
##
## @tutorial(Ballistic Solutions): https://github.com/neclor/ballistic-solutions/blob/main/README.md


## See [BallisticSolutionsVector2Extensions].
static var Vector2E: GDScript = BallisticSolutionsVector2Extensions
## See [BallisticSolutionsVector3Extensions].
static var Vector3E: GDScript = BallisticSolutionsVector3Extensions
## See [BallisticSolutionsVector4Extensions].
static var Vector4E: GDScript = BallisticSolutionsVector4Extensions


## See [Bsc].
static var Calculator: GDScript = Bsc


static var _message_prefix: String = "[BallisticSolutions] - "


static func _warning(message: String = "") -> void:
	push_warning(_message_prefix + message)


static func _error(message: String = "") -> void:
	assert(false, _message_prefix + message)
	push_error(_message_prefix+ message)
