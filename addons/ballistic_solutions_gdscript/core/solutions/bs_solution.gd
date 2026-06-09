@abstract class_name BsSolution extends BallisticSolutions


## Abstract base class for typed ballistic solutions.
##
## @tutorial(Ballistic Solutions): https://github.com/neclor/ballistic-solutions/blob/main/README.md


## The interception time. [constant @GDScript.NAN] if no solution exists.
var time: float: get = get_time
var _time: float = NAN
## Returns the interception time. [constant @GDScript.NAN] if no solution exists.
func get_time() -> float: return _time


## Whether this solution represents a possible interception.
var is_valid: bool: get = get_is_valid
## Returns [code]true[/code] if a valid interception solution was found.
func get_is_valid() -> bool: return not is_nan(_time) and _time > 0
