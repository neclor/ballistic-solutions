class_name Reg extends RealEquationSolver


## Reg - Real Equation Generator [br]
## Equation generator for real-valued polynomial equations up to 4th degree.
##
## @tutorial(RES - Real Equation Solver): https://github.com/neclor/godot-real-equation-solver/blob/main/README.md
##
## @tutorial(Wikipedia: Linear equation): https://en.wikipedia.org/wiki/Linear_equation
## @tutorial(Wikipedia: Quadratic equation): https://en.wikipedia.org/wiki/Quadratic_equation
## @tutorial(Wikipedia: Cubic equation): https://en.wikipedia.org/wiki/Cubic_equation
## @tutorial(Wikipedia: Quartic equation): https://en.wikipedia.org/wiki/Quartic_equation


## Returns the coefficients of a equation with the given roots, in the form: a * x + b = 0, where the leading coefficient a is always 1 [br]
## The function returns: [code][1, b][/code]
##
## [codeblock lang=gdscript]
## Reg.linear(1) # Returns [1, -1]
## [/codeblock]
static func linear(r1: float) -> Array[float]:
	return [1.0, -r1]


## Returns the coefficients of a equation with the given roots, in the form: a * x^2 + b * x + c = 0, where the leading coefficient a is always 1 [br]
## The function returns: [code][1, b, c][/code]
##
## [codeblock lang=gdscript]
## Reg.quadratic(1, 2) # Returns [1, -3, 2]
## [/codeblock]
static func quadratic(r1: float, r2: float) -> Array[float]:
	var b: float = -(r1 + r2)
	var c: float = r1 * r2
	return [1.0, b, c]


## Returns the coefficients of a equation with the given roots, in the form: a * x^3 + b * x^2 + c * x + d = 0, where the leading coefficient a is always 1 [br]
## The function returns: [code][1, b, c, d][/code]
##
## [codeblock lang=gdscript]
## Reg.cubic(1, 2, 3) # Returns [1, -6, 11, -6]
## [/codeblock]
static func cubic(r1: float, r2: float, r3: float) -> Array[float]:
	var b: float = -(r1 + r2 + r3)
	var c: float = (r1 * r2 + r1 * r3 + r2 * r3)
	var d: float = -(r1 * r2 * r3)
	return [1.0, b, c, d]


## Returns the coefficients of a equation with the given roots, in the form: a * x^4 + b * x^3 + c * x^2 + d * x + e = 0, where the leading coefficient a is always 1 [br]
## The function returns: [code][1, b, c, d, e][/code]
##
## [codeblock lang=gdscript]
## Reg.quartic(1, 2, 3, 4) # Returns [1, -10, 35, -50, 24]
## [/codeblock]
static func quartic(r1: float, r2: float, r3: float, r4: float) -> Array[float]:
	var b: float = -(r1 + r2 + r3 + r4)
	var c: float = (r1 * r2 + r1 * r3 + r1 * r4 + r2 * r3 + r2 * r4 + r3 * r4)
	var d: float = -(r1 * r2 * r3 + r1 * r2 * r4 + r1 * r3 * r4 + r2 * r3 * r4)
	var e: float = r1 * r2 * r3 * r4
	return [1.0, b, c, d, e]


func _init() -> void:
	_error("`Reg`: Class is static and should not be instantiated.")
