class_name RealEquationSolverMath extends RealEquationSolver


## Math extension.


## Returns the cube root of [param x].
##
## [codeblock lang=gdscript]
## Res.cbrt(64) # Returns 4
## Res.cbrt(-27) # Returns -3
## [/codeblock]
static func cbrt(x: float) -> float:
	return signf(x) * absf(x) ** (1.0 / 3.0)
