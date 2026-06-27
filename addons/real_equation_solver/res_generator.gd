@abstract class_name ResGenerator extends RealEquationSolver


## Equation generator for real-valued polynomial equations up to 4th degree.
##
## @tutorial(Real Equation Solver): https://github.com/neclor/godot-real-equation-solver/blob/main/README.md
##
## @tutorial(Wikipedia: Linear equation): https://en.wikipedia.org/wiki/Linear_equation
## @tutorial(Wikipedia: Quadratic equation): https://en.wikipedia.org/wiki/Quadratic_equation
## @tutorial(Wikipedia: Cubic equation): https://en.wikipedia.org/wiki/Cubic_equation
## @tutorial(Wikipedia: Quartic equation): https://en.wikipedia.org/wiki/Quartic_equation


const _SCRIPT: GDScript = ResGenerator


# Amplitude of random coefficients. [br]
# Used when generating equations without roots.
const _COEFF_AMPLITUDE: int = 10


## Returns the coefficients of a equation with the given roots, in the form: ax + b = 0. [br]
## Where the leading coefficient a is always 1. [br]
## The function returns: [code][1, b][/code]
##
## [codeblock lang=gdscript]
## ResGenerator.linear(1) # Returns [1, -1]
## [/codeblock]
static func linear(r0: float) -> Array[float]:
	return [1.0, -r0]


## See [method ResGenerator.linear].
static func linear_array(roots: Array[float]) -> Array[float]:
	if roots.size() != 1:
		_ResLogger.format_error(_SCRIPT, linear_array, "There must be exactly 1 root", [])
		return []
	return linear(roots[0])


## Returns the coefficients of a equation with the given roots, in the form: ax² + bx + c = 0. [br]
## Where the leading coefficient a is always 1. [br]
## The function returns: [code][1, b, c][/code].
##
## [codeblock lang=gdscript]
## ResGenerator.quadratic(1, 2) # Returns [1, -3, 2]
## [/codeblock]
static func quadratic(...roots: Array) -> Array[float]:
	if roots.size() > 2:
		_ResLogger.format_error(_SCRIPT, quadratic, "There cannot be more than 2 arguments", [])
		return []

	if not ResMath.is_numeric_array(roots):
		_ResLogger.format_error(_SCRIPT, quadratic, "One of the arguments is not a number", [])
		return []

	return quadratic_array(Array(roots, Variant.Type.TYPE_FLOAT, "", null))


## See [method ResGenerator.quadratic].
static func quadratic_array(roots: Array[float]) -> Array[float]:
	if roots.size() > 2:
		_ResLogger.format_error(_SCRIPT, quadratic_array, "There cannot be more than 2 arguments", [])
		return []

	var b: float
	var c: float

	if roots.is_empty(): 
		# (x² + p) + q = 0
		var p: float = randi_range(-_COEFF_AMPLITUDE, _COEFF_AMPLITUDE)
		var q: float = randi_range(1, _COEFF_AMPLITUDE)
		b = 2 * p
		c = p * p + q

	else:
		var r0: float = roots[0]
		var r1: float = roots[1] if roots.size() > 1 else r0
		b = -(r0 + r1)
		c = r0 * r1

	return [1.0, b, c]


## Returns the coefficients of a equation with the given roots, in the form: ax³ + bx² + cx + d = 0. [br]
## Where the leading coefficient a is always 1. [br]
## The function returns: [code][1, b, c, d][/code].
##
## [codeblock lang=gdscript]
## ResGenerator.cubic(1, 2, 3) # Returns [1, -6, 11, -6]
## [/codeblock]
static func cubic(...roots: Array) -> Array[float]:
	if roots.is_empty() or roots.size() > 3:
		_ResLogger.format_error(_SCRIPT, cubic, "There must be 1 to 3 arguments", [])
		return []

	if not ResMath.is_numeric_array(roots):
		_ResLogger.format_error(_SCRIPT, cubic, "One of the arguments is not a number", [])
		return []

	return cubic_array(Array(roots, Variant.Type.TYPE_FLOAT, "", null))


## See [method ResGenerator.cubic].
static func cubic_array(roots: Array[float]) -> Array[float]:
	if roots.is_empty() or roots.size() > 3:
		_ResLogger.format_error(_SCRIPT, cubic_array, "There must be 1 to 3 arguments", [])
		return []

	var r0: float = roots[0]
	var r1: float = roots[1] if roots.size() > 1 else r0
	var r2: float = roots[2] if roots.size() > 2 else r1

	var b: float = -(r0 + r1 + r2)
	var c: float = (r0 * r1 + r0 * r2 + r1 * r2)
	var d: float = -(r0 * r1 * r2)

	return [1.0, b, c, d]


## Returns the coefficients of a equation with the given roots, in the form: ax⁴ + bx³ + cx² + dx + e = 0. [br]
## Where the leading coefficient a is always 1. [br]
## The function returns: [code][1, b, c, d, e][/code].
##
## [codeblock lang=gdscript]
## ResGenerator.quartic(1, 2, 3, 4) # Returns [1, -10, 35, -50, 24]
## [/codeblock]
static func quartic(...roots: Array) -> Array[float]:
	if roots.size() > 4:
		_ResLogger.format_error(_SCRIPT, quartic, "There cannot be more than 4 arguments", [])
		return []

	if not ResMath.is_numeric_array(roots):
		_ResLogger.format_error(_SCRIPT, quartic, "One of the arguments is not a number", [])
		return []

	return quartic_array(Array(roots, Variant.Type.TYPE_FLOAT, "", null))


## See [method ResGenerator.quartic].
static func quartic_array(roots: Array[float]) -> Array[float]:
	if roots.size() > 4:
		_ResLogger.format_error(_SCRIPT, quartic_array, "There cannot be more than 4 arguments", [])
		return []

	var b: float
	var c: float
	var d: float
	var e: float

	if roots.is_empty():
		# (x² + px + q)^2 + r = 0
		var p: float = randi_range(-_COEFF_AMPLITUDE, _COEFF_AMPLITUDE)
		var q: float = randi_range(-_COEFF_AMPLITUDE, _COEFF_AMPLITUDE)
		var r: float = randi_range(1, _COEFF_AMPLITUDE)
		b = 2 * p
		c = p * p + 2 * q
		d = 2 * p * q
		e = q * q + r

	else:
		var r0: float = roots[0]
		var r1: float = roots[1] if roots.size() > 1 else r0
		var r2: float = roots[2] if roots.size() > 2 else r1
		var r3: float = roots[3] if roots.size() > 3 else r2
		b = -(r0 + r1 + r2 + r3)
		c = (r0 * r1 + r0 * r2 + r0 * r3 + r1 * r2 + r1 * r3 + r2 * r3)
		d = -(r0 * r1 * r2 + r0 * r1 * r3 + r0 * r2 * r3 + r1 * r2 * r3)
		e = r0 * r1 * r2 * r3

	return [1.0, b, c, d, e]
