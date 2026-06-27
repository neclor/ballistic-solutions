@abstract class_name _BsLogger extends _BsUtils


## Logger


const _LIBRARY: GDScript = BallisticSolutions


## Push error.
static func error(script: GDScript, method: Callable, message: String = "", returned: Variant = "") -> void:
	var formated_message: String = format_message(script, method, message, returned)
	push_error(formated_message)
	assert(false, formated_message)


## Format message.
static func format_message(script: GDScript, method: Callable, message: String = "", returned: Variant = "") -> String:
	var text: String = "[%s] - `%s.%s`" % [_LIBRARY.get_global_name(), script.get_global_name(), method.get_method()]
	if not message.is_empty():
		text += ": %s." % message
	if not ((returned is String or returned is StringName) and (returned as String).is_empty()):
		text += " Returned %s." % str(returned)
	return text
