class_name RealEquationSolver extends Object


## Equation solver and generator for real-valued polynomial equations up to 4th degree.
##
## @tutorial(RES - Real Equation Solver): https://github.com/neclor/godot-real-equation-solver/blob/main/README.md


## See [RealEquationSolverMath].
static var Math: GDScript = RealEquationSolverMath


## See [Res].
static var Solver: GDScript = Res
## See [Reg].
static var Generator: GDScript = Reg


static var _message_prefix: String = "[RealEquationSolver] - "


static func _error(message: String = "") -> void:
	assert(false, _message_prefix + message)
	push_error(_message_prefix + message)


func _init() -> void:
	_error("`RealEquationSolver`: Class is static and should not be instantiated.")
