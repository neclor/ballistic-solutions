@abstract class_name BsSolution extends BallisticSolutions


## Abstract base class for typed ballistic solutions.
##
## [BsSolution2D] - Ballistic solution for [Vector2]. [br]
## [BsSolution3D] - Ballistic solution for [Vector3]. [br]
## [BsSolution4D] - Ballistic solution for [Vector4].


## The interception time.
var time: float: get = get_time
var _time: float
func get_time() -> float: return _time
