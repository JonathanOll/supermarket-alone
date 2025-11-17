extends Object
class_name Observable

signal value_changed(old_value, new_value)

var _value

func _init(v):
	_value = v

func set_value(v) -> void:
	if _value != v:
		var old_value = _value
		_value = v
		value_changed.emit(old_value, _value)
	
func get_value():
	return _value

func observe(fun: Callable):
	value_changed.connect(fun)
