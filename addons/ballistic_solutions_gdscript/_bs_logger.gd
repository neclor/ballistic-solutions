@abstract class_name _BsLogger extends BallisticSolutions


## Logger


static var _message_prefix: String = "[BallisticSolutions] - "


static func error(message: String = "") -> void:
	assert(false, _message_prefix + message)
	push_error(_message_prefix + message)


static func warning(message: String = "") -> void:
	push_warning(_message_prefix + message)
