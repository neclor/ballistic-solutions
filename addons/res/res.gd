class_name RES extends Object


## Equation solver for finding real roots of equations up to 4th degree for Godot.
##
## @tutorial(Wikipedia: Linear equation): https://en.wikipedia.org/wiki/Linear_equation
## @tutorial(Wikipedia: Quadratic equation): https://en.wikipedia.org/wiki/Quadratic_equation
## @tutorial(Wikipedia: Cubic equation): https://en.wikipedia.org/wiki/Cubic_equation
## @tutorial(Wikipedia: Vieta's trigonometric formula): https://ru.wikipedia.org/wiki/%D0%A2%D1%80%D0%B8%D0%B3%D0%BE%D0%BD%D0%BE%D0%BC%D0%B5%D1%82%D1%80%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%B0%D1%8F_%D1%84%D0%BE%D1%80%D0%BC%D1%83%D0%BB%D0%B0_%D0%92%D0%B8%D0%B5%D1%82%D0%B0
## @tutorial(Wikipedia: Quartic equation): https://en.wikipedia.org/wiki/Quartic_equation
## @tutorial(Wikipedia: Ferrari's solution): https://ru.wikipedia.org/wiki/%D0%9C%D0%B5%D1%82%D0%BE%D0%B4_%D0%A4%D0%B5%D1%80%D1%80%D0%B0%D1%80%D0%B8


## Returns the cube root of [param x].
##
## [codeblock lang=gdscript]
## RES.cbrt(64) # Returns 4
## RES.cbrt(-27) # Returns -3
## [/codeblock]
static func cbrt(x: float) -> float:
	return signf(x) * absf(x) ** (1.0 / 3.0)


## Returns a real root of an equation of the form: [u][param a] * x + [param b] = 0[/u]
##
## [codeblock lang=gdscript]
## RES.solve_linear(5, -10) # Returns 2
## RES.solve_linear(0, 1) # Returns NAN
## [/codeblock]
##
## [br]
## [url=https://en.wikipedia.org/wiki/Linear_equation]See Linear equation.[/url] 
static func solve_linear(a: float, b: float) -> float:
	if is_zero_approx(a): return NAN
	return -b / a


## Returns a sorted array of real roots of an equation of the form: [u][param a] * x^2 + [param b] * x + [param c] = 0[/u]
##
## [codeblock lang=gdscript]
## RES.solve_quadratic(1, 1, -6) # Returns [-3, 2]
## [/codeblock]
##
## [br]
## [url=https://en.wikipedia.org/wiki/Quadratic_equation]See Quadratic equation.[/url] 
static func solve_quadratic(a: float, b: float, c: float) -> Array[float]:
	if is_zero_approx(a):
		var x: float = solve_linear(b, c)
		if is_nan(x): return []
		return [x]

	var p: float = b / a
	var q: float = c / a

	var D: float = p ** 2 - 4 * q

	if is_zero_approx(D): return [-p / 2]

	if D > 0:
		var neg_half_p: float = -p / 2
		var half_sqrt_D: float = sqrt(D) / 2
		var x_values: Array[float] = [neg_half_p + half_sqrt_D, neg_half_p - half_sqrt_D]

		x_values.sort()
		return x_values

	return []


## Returns a sorted array of real roots of an equation of the form: [u][param a] * x^3 + [param b] * x^2 + [param c] * x + [param d] = 0[/u]
##
## [codeblock lang=gdscript]
## RES.solve_cubic(2, -11, 12, 9) # Returns [-0.5, 3]
## [/codeblock]
##
## [b][color=GOLD]Warning:[/color][/b] For large argument values, answers may be inaccurate or incorrect. [br]
## [br]
## [url=https://en.wikipedia.org/wiki/Cubic_equation]See Cubic equation.[/url][br]
## [url=https://ru.wikipedia.org/wiki/%D0%A2%D1%80%D0%B8%D0%B3%D0%BE%D0%BD%D0%BE%D0%BC%D0%B5%D1%82%D1%80%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%B0%D1%8F_%D1%84%D0%BE%D1%80%D0%BC%D1%83%D0%BB%D0%B0_%D0%92%D0%B8%D0%B5%D1%82%D0%B0]See Vieta's trigonometric formula.[/url]
static func solve_cubic(a: float, b: float, c: float, d: float) -> Array[float]:
	if is_zero_approx(a): return solve_quadratic(b, c, d)

	var p: float = b / a
	var q: float = c / a
	var r: float = d / a

	var p_div_3: float = p / 3

	var Q: float = p_div_3 ** 2 - q / 3
	var R: float = p_div_3 ** 3 + (r - p_div_3 * q) / 2

	var Q_pow_3: float = Q ** 3
	var R_pow_2: float = R ** 2

	var x_values: Array[float] = []
	if is_equal_approx(Q_pow_3, R_pow_2):
		if is_zero_approx(R):
			x_values.append(-p_div_3)
		else:
			var cbrt_R: float = cbrt(R)
			x_values.append(-2 * cbrt_R - p_div_3)
			x_values.append(cbrt_R - p_div_3)

	elif Q_pow_3 > R_pow_2:
		var f: float = acos(R / sqrt(Q_pow_3)) / 3
		var neg_double_sqrt_Q: float = -2 * sqrt(Q)
		var TAU_div_3: float = TAU / 3
		x_values.append(neg_double_sqrt_Q * cos(f) - p_div_3)
		x_values.append(neg_double_sqrt_Q * cos(f + TAU_div_3) - p_div_3)
		x_values.append(neg_double_sqrt_Q * cos(f - TAU_div_3) - p_div_3)

	else:
		if is_zero_approx(Q):
			x_values.append(-cbrt(r - p_div_3 ** 3) - p_div_3)
		elif Q > 0:
			var f: float = acosh(absf(R) / sqrt(Q_pow_3)) / 3
			x_values.append(-2 * signf(R) * sqrt(Q) * cosh(f) - p_div_3)
		else:
			var f: float = asinh(absf(R) / sqrt(absf(Q_pow_3))) / 3
			x_values.append(-2 * signf(R) * sqrt(absf(Q)) * sinh(f) - p_div_3)

	x_values.sort()
	return x_values


## Returns a sorted array of real roots of an equation of the form: [u][param a] * x^4 + [param b] * x^3 + [param c] * x^2 + [param d] * x + [param e] = 0[/u]
##
## [codeblock lang=gdscript]
## RES.solve_quartic(1, -10, 35, -50, 24) # Returns [1, 2, 3, 4]
## [/codeblock]
##
## [b][color=GOLD]Warning:[/color][/b] For large argument values, answers may be inaccurate or incorrect.[br]
## [br]
## [url=https://en.wikipedia.org/wiki/Quartic_equation]See Quartic equation.[/url][br]
## [url=https://ru.wikipedia.org/wiki/%D0%9C%D0%B5%D1%82%D0%BE%D0%B4_%D0%A4%D0%B5%D1%80%D1%80%D0%B0%D1%80%D0%B8]See Ferrari's solution.[/url]
static func solve_quartic(a: float, b: float, c: float, d: float, e: float) -> Array[float]:
	if is_zero_approx(a): return solve_cubic(b, c, d, e)

	var a1: float = b / a
	var b1: float = c / a
	var c1: float = d / a
	var d1: float = e / a

	var half_a1: float = a1 / 2
	var half_a1_squared: float = half_a1 ** 2

	# Converting to a depressed quartic. x = u - a1 / 4 -> u^4 + p * u^2 + q * u + r = 0
	var p: float = (-3.0 / 2.0) * half_a1_squared + b1
	var q: float = (half_a1 ** 3) - half_a1 * b1 + c1
	var r: float = (-3.0 / 16.0) * (half_a1_squared ** 2) + half_a1_squared * b1 / 4 - half_a1 * c1 / 2 + d1

	var u_values: Array[float] = []
	if is_zero_approx(q):
		for u_squared in solve_quadratic(1, p, r):
			if is_zero_approx(u_squared):
				u_values.append(0)
			elif u_squared > 0:
				var u: float = sqrt(u_squared)
				u_values.append(u)
				u_values.append(-u)

	else:
		var cubic_b: float = 2.5 * p
		var cubic_c: float = 2 * (p ** 2) - r
		var cubic_d: float = (p ** 3 - p * r - (q / 2) ** 2) / 2

		var y: float = solve_cubic(1, cubic_b, cubic_c, cubic_d).max()
		var p_add_y: float = p + y
		var sqrt_p_add_2y: float = sqrt(p_add_y + y)
		var half_q_div_sqrt_p_add_2y: float = q / (2 * sqrt_p_add_2y)

		var new_u_values: Array[float] = solve_quadratic(1, -sqrt_p_add_2y, p_add_y + half_q_div_sqrt_p_add_2y) + solve_quadratic(1, sqrt_p_add_2y, p_add_y - half_q_div_sqrt_p_add_2y)
		for new_u in new_u_values:
			var has_u: bool = false
			for u in u_values:
				if is_equal_approx(new_u, u):
					has_u = true
					break
			if not has_u: u_values.append(new_u)

	# Converting back from depressed quartic. x = u - a1 / 4
	var a1_div_4: float = a1 / 4
	var x_values: Array[float] = Array(u_values.map(func(u: float) -> float: return u - a1_div_4), TYPE_FLOAT, "", null)
	x_values.sort()
	return x_values
