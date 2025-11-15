extends Control
class_name Shop

func open():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	show()

func close():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hide()

func toggle():
	if visible:
		close()
	else:
		open()
