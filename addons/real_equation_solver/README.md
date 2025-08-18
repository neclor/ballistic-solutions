# RES - Real Equation Solver
Equation solver and generator for real-valued polynomial equations up to degree 4 in Godot.


## Methods
```gdscript
Res


float cbrt(x: float) static


# Solve

float solve_linear(a: float, b: float) static

Array[float] solve_quadratic(a: float, b: float, c: float) static

Array[float] solve_cubic(a: float, b: float, c: float, d: float) static

Array[float] solve_quartic(a: float, b: float, c: float, d: float, e: float) static


# Generate

Array[float] generate_linear(r1: float) static

Array[float] generate_quadratic(r1: float, r2: float) static

Array[float] generate_cubic(r1: float, r2: float, r3: float) static

Array[float] generate_quartic(r1: float, r2: float, r3: float, r4: float) static
```


## Example
```gdscript
func example() -> void:
	print(Res.cbrt(27)) # Prints 3
	print(Res.solve_linear(5, -10)) # Prints 2
	print(Res.solve_quadratic(1, 1, -6)) # Prints [-3, 2]
	print(Res.solve_cubic(2, -11, 12, 9)) # Prints [-0.5, 3]
	print(Res.solve_quartic(1, -10, 35, -50, 24)) # Prints [1, 2, 3, 4]

	print(Res.generate_quartic(1, 2, 3, 4)) # Prints [1, -10, 35, -50, 24]
```
