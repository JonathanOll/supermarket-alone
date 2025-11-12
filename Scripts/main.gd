extends Node3D

@export var navigation_region: NavigationRegion3D
@export var player: Player

var npc: NPC

func _ready() -> void:
	for i in range(len(Global.products)):
		var product = Global.products[i]
		product.load()
		
		var box = Box.create(product)
		box.position = Vector3(0, 10 + 2*i, -10)
		navigation_region.add_child(box)
	
	var rack = Rack.create()
	rack.position = Vector3(-8, 0, -22)
	navigation_region.add_child(rack)
	
	var aisle = Aisle.create()
	aisle.position = Vector3(-8, 0, -5)
	navigation_region.add_child(aisle)
	
	var checkout_counter = CheckoutCounter.create()
	checkout_counter.position = Vector3(7, 0, 11)
	navigation_region.add_child(checkout_counter)
	
	npc = NPC.create()
	npc.position = Vector3(10, 10, -10)
	navigation_region.add_child(npc)
	
	navigation_region.bake_navigation_mesh()
	
	npc.go_to(Vector3(-10, 0, 10))
	
func _process(delta):
	if Input.is_action_pressed("dev"):
		npc.go_to(player.global_position)
	
	
