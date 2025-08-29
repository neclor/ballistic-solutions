# RES - Real Equation Solver

**Real Equation Solver** - Equation solver and generator for real-valued polynomial equations up to 4th degree."

---

## Table of Contents

1. [Installation](#installation)
2. [Example](#example)
3. [Reference](#reference)
4. [Contributing](#contributing)

---

## <a name="installation"></a>Installation

### Installation
1. Just download the addon from the [Asset Library](https://godotengine.org/asset-library/asset/2998) or from GitHub.

---

## <a name="example"></a>Example
```gdscript
func example() -> void:
	print(Res.linear(5, -10)) # Prints 2
	print(Res.quadratic(1, 1, -6)) # Prints [-3, 2]
	print(Res.cubic(2, -11, 12, 9)) # Prints [-0.5, 3]
	print(Res.quartic(1, -10, 35, -50, 24)) # Prints [1, 2, 3, 4]

	print(Reg.quartic(1, 2, 3, 4)) # Prints [1, -10, 35, -50, 24]
```

---

## <a name="reference"></a>Reference

1. [Res](#res)
	1. [Solve](#solve)
2. [Reg](#reg)
	1. [Generate](#generate)

---

### <a name="res"></a>Class: `Res`

#### <a name="time"></a>Methods: Solve

```gdscript
float linear(a: float, b: float) static
```

```gdscript
Array[float] quadratic(a: float, b: float, c: float) static
```

```gdscript
Array[float] cubic(a: float, b: float, c: float, d: float) static
```

```gdscript
Array[float] quartic(a: float, b: float, c: float, d: float, e: float) static
```

---

### <a name="reg"></a>Class: `Reg`

#### <a name="time"></a>Methods: Generate

```gdscript
Array[float] linear(r1: float) static
```

```gdscript
Array[float] quadratic(r1: float, r2: float) static
```

```gdscript
Array[float] cubic(r1: float, r2: float, r3: float) static
```

```gdscript
Array[float] quartic(r1: float, r2: float, r3: float, r4: float) static
```

---

## <a name="contributing"></a>Contributing

- Contributions are welcome. Open an issue or PR.

---
