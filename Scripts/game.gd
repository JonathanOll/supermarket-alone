extends Node3D
class_name Game

static var game: Game

@export var navigation_region: NavigationRegion3D
@export var player: Player

var aisles: Array[Aisle] = []
var racks: Array[Rack] = []
var checkout_counters: Array[CheckoutCounter] = []
var npcs: Array[NPC] = []


func _ready() -> void:
	assert(game == null) # pr le singleton
	game = self
	init_map()
	
func _process(delta):
	if Input.is_action_pressed("dev"):
		for npc in npcs:
			npc.go_to(player.global_position)

func init_map():
	for i in range(len(Global.products)):
		var product = Global.products[i]
		product.load()
		
		var box = Box.create(product)
		box.position = Vector3(0, 10 + 2*i, -10)
		navigation_region.add_child(box)
	
	var rack = add_rack(Vector3(-8, 0, -22), false)
	
	var aisle = add_aisle(Vector3(-8, 0, -5), false)
	aisle.fill_randomly()
	
	add_checkout_counter(Vector3(7, 0, 11), false)
	
	navigation_region.bake_navigation_mesh()
	
	for i in range(4):
		var npc = add_npc(Vector3(20, 10, -10 + 5*i))

func add_aisle(position: Vector3 = Vector3.ZERO, bake_navmesh: bool = true) -> Aisle:
	var aisle = Aisle.create()
	aisle.position = position
	navigation_region.add_child(aisle)
	aisles.append(aisle)
	if (bake_navmesh):
		navigation_region.bake_navigation_mesh()
	return aisle
	
func add_rack(position: Vector3 = Vector3.ZERO, bake_navmesh: bool = true) -> Rack:
	var rack = Rack.create()
	rack.position = position
	navigation_region.add_child(rack)
	racks.append(rack)
	if (bake_navmesh):
		navigation_region.bake_navigation_mesh()
	return rack

func add_checkout_counter(position: Vector3 = Vector3.ZERO, bake_navmesh: bool = true) -> CheckoutCounter:
	var checkout_counter = CheckoutCounter.create()
	checkout_counter.position = position
	navigation_region.add_child(checkout_counter)
	if (bake_navmesh):
		navigation_region.bake_navigation_mesh()
	return checkout_counter

func add_npc(position: Vector3 = Vector3.ZERO) -> NPC:
	var npc = NPC.create()
	npc.position = position
	navigation_region.add_child(npc)
	npcs.append(npc)
	return npc
	
