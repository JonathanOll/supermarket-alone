extends Object
class_name Observable

signal value_changed(new_value)

var _value

func set_value(v) -> void:
	if _value != v:
		_value = v
		value_changed.emit(v)
	
func get_value():
	return _value
