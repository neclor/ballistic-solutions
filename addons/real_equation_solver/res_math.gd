@abstract class_name ResMath extends RealEquationSolver


## Math library


## Returns the cube root of [param x].
##
## [codeblock lang=gdscript]
## ResMath.cbrt(64) # Returns 4
## ResMath.cbrt(-27) # Returns -3
## [/codeblock]
static func cbrt(x: float) -> float:
	return signf(x) * absf(x) ** (1.0 / 3.0)


## Checks if all elements are numeric.
static func is_numeric_array(array: Array) -> bool:
	return array.all(func(i: Variant) -> bool: return i is int or i is float)
