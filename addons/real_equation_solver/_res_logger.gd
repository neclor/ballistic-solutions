@abstract class_name _ResLogger extends RealEquationSolver


## Logger


const _SCRIPT: GDScript = RealEquationSolver


## Push error.
static func error(message: String = "") -> void:
	push_error(message)
	assert(false, message)


## Format and push error.
static func format_error(script: GDScript, method: Callable, message: String = "", returned: Variant = "") -> void:
	error(format_message(script, method, message, returned))


## Format message.
static func format_message(script: GDScript, method: Callable, message: String = "", returned: Variant = "") -> String:
	var text: String = "[%s] - `%s.%s`" % [_SCRIPT.get_global_name(), script.get_global_name(), method.get_method()]
	if not message.is_empty():
		text += ": %s." % message
	if not ((returned is String or returned is StringName) and returned.is_empty()):
		text += " Returned " + str(returned) + "."
	return text


## Format and push warning.
static func format_warning(script: GDScript, method: Callable, message: String = "", returned: Variant = "") -> void:
	push_warning(format_message(script, method, message, returned))
