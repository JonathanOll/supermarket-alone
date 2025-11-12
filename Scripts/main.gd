extends Node3D

func _ready() -> void:
	for i in range(len(Global.products)):
		var product = Global.products[i]
		product.load()
		
		var box = Box.create(product)
		box.position = Vector3(0, 10 + 2*i, -10)
		add_child(box)
	
	var rack = Rack.create()
	rack.position = Vector3(-8, 0, -22)
	add_child(rack)
	
	var aisle = Aisle.create()
	aisle.position = Vector3(-8, 0, -5)
	add_child(aisle)
	
	var checkout_counter = CheckoutCounter.create()
	checkout_counter.position = Vector3(7, 0, 11)
	add_child(checkout_counter)
	
	var npc = NPC.create()
	npc.position = Vector3(10, 10, -10)
	add_child(npc)
	
