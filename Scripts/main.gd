extends Node3D

func _ready() -> void:
	for i in range(len(Global.products)):
		var product = Global.products[i]
		product.load()
		
		var box = Box.create(product)
		box.position = Vector3(0, 10 + 2*i, -10)
		add_child(box)
	
	var rack = Rack.create()
	rack.position = Vector3(-8,0,-22)
	add_child(rack)
	
