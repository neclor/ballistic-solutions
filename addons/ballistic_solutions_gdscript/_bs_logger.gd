@abstract class_name _BsLogger extends BallisticSolutions


## Logger


const _LIBRARY_NAME: String = "BallisticSolutions"


## Push error.
static func error(message: String = "") -> void:
	push_error(message)
	assert(false, message)


## Format and push error.
static func format_error(script: String, method: String, message: String = "", returned: String = "") -> void:
	error(format_message(script, method, message, returned))


## Format message.
static func format_message(script: String, method: String, message: String = "", returned: String = "") -> String:
	return "[%s] - `%s.%s`" % [_LIBRARY_NAME, script, method] + ("" if message.is_empty() else ": %s." % message) + ("" if returned.is_empty() else " Returned %s." % returned)


## Format and push warning.
static func format_warning(script: String, method: String, message: String = "", returned: String = "") -> void:
	push_warning(format_message(script, method, message, returned))
