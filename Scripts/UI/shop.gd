extends Control
class_name Shop


@export var product_container: FlowContainer

func _ready() -> void:
	
	await get_tree().create_timer(1).timeout
	
	for prod in Global.products:
		product_container.add_child(BuyableProduct.create(prod))
		print(prod)

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
