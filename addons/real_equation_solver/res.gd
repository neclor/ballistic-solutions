class_name Res extends RealEquationSolver


## Res - Real Equation Solver [br]
## Equation solver for real-valued polynomial equations up to 4th degree.
##
## @tutorial(RES - Real Equation Solver): https://github.com/neclor/godot-real-equation-solver/blob/main/README.md
##
## @tutorial(Wikipedia: Linear equation): https://en.wikipedia.org/wiki/Linear_equation
## @tutorial(Wikipedia: Quadratic equation): https://en.wikipedia.org/wiki/Quadratic_equation
## @tutorial(Wikipedia: Cubic equation): https://en.wikipedia.org/wiki/Cubic_equation
## @tutorial(Wikipedia: Vieta's trigonometric formula): https://ru.wikipedia.org/wiki/%D0%A2%D1%80%D0%B8%D0%B3%D0%BE%D0%BD%D0%BE%D0%BC%D0%B5%D1%82%D1%80%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%B0%D1%8F_%D1%84%D0%BE%D1%80%D0%BC%D1%83%D0%BB%D0%B0_%D0%92%D0%B8%D0%B5%D1%82%D0%B0
## @tutorial(Wikipedia: Quartic equation): https://en.wikipedia.org/wiki/Quartic_equation
## @tutorial(Wikipedia: Ferrari's solution): https://ru.wikipedia.org/wiki/%D0%9C%D0%B5%D1%82%D0%BE%D0%B4_%D0%A4%D0%B5%D1%80%D1%80%D0%B0%D1%80%D0%B8


## Returns a real root of an equation of the form: [param a] * x + [param b] = 0
##
## [codeblock lang=gdscript]
## Res.linear(5, -10) # Returns 2
## Res.linear(0, 1) # Returns NAN
## [/codeblock]
static func linear(a: float, b: float) -> float:
	if is_zero_approx(a): return NAN
	return -b / a


## Returns a sorted array of real roots of an equation of the form: [param a] * x^2 + [param b] * x + [param c] = 0
##
## [codeblock lang=gdscript]
## Res.quadratic(1, 1, -6) # Returns [-3, 2]
## [/codeblock]
static func quadratic(a: float, b: float, c: float) -> Array[float]:
	if is_zero_approx(a):
		var root: float = linear(b, c)
		if is_nan(root): return []
		return [root]

	var p: float = b / a
	var q: float = c / a

	var D: float = p * p - 4 * q

	# The check for 0 must be before the check for the sign
	if is_zero_approx(D): return [-p / 2]

	if D < 0: return []

	var neg_half_p: float = -p / 2
	var half_sqrt_D: float = sqrt(D) / 2
	var roots: Array[float] = [neg_half_p + half_sqrt_D, neg_half_p - half_sqrt_D]

	roots.sort()
	return roots


## Returns a sorted array of real roots of an equation of the form: [param a] * x^3 + [param b] * x^2 + [param c] * x + [param d] = 0
##
## [codeblock lang=gdscript]
## Res.cubic(2, -11, 12, 9) # Returns [-0.5, 3]
## [/codeblock]
##
## [b][color=GOLD]Warning:[/color][/b] For large argument values, answers may be inaccurate or incorrect. [br]
static func cubic(a: float, b: float, c: float, d: float) -> Array[float]:
	if is_zero_approx(a): return quadratic(b, c, d)

	var p: float = b / a
	var q: float = c / a
	var r: float = d / a

	var p_div_3: float = p / 3
	var p_div_3_pow_2: float = p_div_3 * p_div_3
	var p_div_3_pow_3: float = p_div_3_pow_2 * p_div_3

	var Q: float = p_div_3_pow_2 - q / 3
	var R: float = p_div_3_pow_3 + (r - p_div_3 * q) / 2

	var Q_pow_3: float = Q * Q * Q
	var R_pow_2: float = R * R

	var roots: Array[float] = []
	if is_equal_approx(Q_pow_3, R_pow_2):
		if is_zero_approx(R):
			roots.append(-p_div_3)
		else:
			var cbrt_R: float = RealEquationSolverMath.cbrt(R)
			roots.append(-2 * cbrt_R - p_div_3)
			roots.append(cbrt_R - p_div_3)

	elif Q_pow_3 > R_pow_2:
		var f: float = acos(R / sqrt(Q_pow_3)) / 3
		var neg_double_sqrt_Q: float = -2 * sqrt(Q)
		var TAU_div_3: float = TAU / 3
		roots.append(neg_double_sqrt_Q * cos(f) - p_div_3)
		roots.append(neg_double_sqrt_Q * cos(f + TAU_div_3) - p_div_3)
		roots.append(neg_double_sqrt_Q * cos(f - TAU_div_3) - p_div_3)

	else:
		if is_zero_approx(Q):
			roots.append(-RealEquationSolverMath.cbrt(r - p_div_3_pow_3) - p_div_3)
		elif Q > 0:
			var f: float = acosh(absf(R) / sqrt(Q_pow_3)) / 3
			roots.append(-2 * signf(R) * sqrt(Q) * cosh(f) - p_div_3)
		else:
			var f: float = asinh(absf(R) / sqrt(absf(Q_pow_3))) / 3
			roots.append(-2 * signf(R) * sqrt(absf(Q)) * sinh(f) - p_div_3)

	roots.sort()
	return roots


## Returns a sorted array of real roots of an equation of the form: [param a] * x^4 + [param b] * x^3 + [param c] * x^2 + [param d] * x + [param e] = 0
##
## [codeblock lang=gdscript]
## Res.quartic(1, -10, 35, -50, 24) # Returns [1, 2, 3, 4]
## [/codeblock]
##
## [b][color=GOLD]Warning:[/color][/b] For large argument values, answers may be inaccurate or incorrect.[br]
static func quartic(a: float, b: float, c: float, d: float, e: float) -> Array[float]:
	if is_zero_approx(a): return cubic(b, c, d, e)

	var a1: float = b / a
	var b1: float = c / a
	var c1: float = d / a
	var d1: float = e / a

	var half_a1: float = a1 / 2
	var half_a1_pow_2: float = half_a1 * half_a1
	var half_a1_pow_3: float = half_a1_pow_2 * half_a1

	# Converting to a depRessed quartic. x = u - a1 / 4 -> u^4 + p * u^2 + q * u + r = 0
	var p: float = (-3.0 / 2.0) * half_a1_pow_2 + b1
	var q: float = half_a1_pow_3 - half_a1 * b1 + c1
	var r: float = (-3.0 / 16.0) * (half_a1_pow_2 * half_a1_pow_2) + half_a1_pow_2 * b1 / 4 - half_a1 * c1 / 2 + d1

	var u_values: Array[float] = []
	if is_zero_approx(q):
		for u_pow_2 in quadratic(1, p, r):
			if is_zero_approx(u_pow_2):
				u_values.append(0)
			elif u_pow_2 > 0:
				var u: float = sqrt(u_pow_2)
				u_values.append(u)
				u_values.append(-u)

	else:
		var p_pow_2: float = p * p
		var p_pow_3: float = p_pow_2 * p
		
		var half_q: float = q / 2
		
		var cubic_b: float = 2.5 * p
		var cubic_c: float = 2 * p_pow_2 - r
		var cubic_d: float = (p_pow_3 - p * r - half_q * half_q) / 2

		var y: float = cubic(1, cubic_b, cubic_c, cubic_d).max()
		var p_add_y: float = p + y
		var sqrt_p_add_2y: float = sqrt(p_add_y + y)
		var half_q_div_sqrt_p_add_2y: float = half_q / sqrt_p_add_2y

		var new_u_values: Array[float] = quadratic(1, -sqrt_p_add_2y, p_add_y + half_q_div_sqrt_p_add_2y) + quadratic(1, sqrt_p_add_2y, p_add_y - half_q_div_sqrt_p_add_2y)
		for new_u in new_u_values:
			var has_u: bool = false
			for u in u_values:
				if is_equal_approx(new_u, u):
					has_u = true
					break
			if not has_u: u_values.append(new_u)

	# Converting back from depRessed quartic. x = u - a1 / 4
	var a1_div_4: float = a1 / 4
	var roots: Array[float] = Array(u_values.map(func(u: float) -> float: return u - a1_div_4), TYPE_FLOAT, "", null)
	roots.sort()
	return roots
