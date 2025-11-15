extends NavigationRegion3D
class_name Level

var aisles: Array[Aisle] = []
var racks: Array[Rack] = []
var checkout_counters: Array[CheckoutCounter] = []
var npcs: Array[NPC] = []

func init():	
	var rack = add_rack(Vector3(-8, 0, -22), false)
	
	var aisle = add_aisle(Vector3(-8, 0, -5), false)
	aisle.fill_randomly()
	
	add_checkout_counter(Vector3(10, 0, 15), false)
	
	bake_navigation_mesh()
	
	await get_tree().create_timer(1).timeout
	for i in range(len(Global.products)):
		var product = Global.products[i]
		product.load()
		
		var box = Box.create(product)
		box.position = Vector3(0, 10 + 2*i, -10)
		add_child(box)

func add_aisle(position: Vector3 = Vector3.ZERO, bake_navmesh: bool = true) -> Aisle:
	var aisle = Aisle.create()
	aisle.position = position
	aisles.append(aisle)
	add_child(aisle)
	if (bake_navmesh):
		bake_navigation_mesh()
	return aisle
	
func add_rack(position: Vector3 = Vector3.ZERO, bake_navmesh: bool = true) -> Rack:
	var rack = Rack.create()
	rack.position = position
	racks.append(rack)
	add_child(rack)
	if (bake_navmesh):
		bake_navigation_mesh()
	return rack

func add_checkout_counter(position: Vector3 = Vector3.ZERO, bake_navmesh: bool = true) -> CheckoutCounter:
	var checkout_counter = CheckoutCounter.create()
	checkout_counter.position = position
	checkout_counters.append(checkout_counter)
	add_child(checkout_counter)
	if (bake_navmesh):
		bake_navigation_mesh()
	return checkout_counter

func add_npc(position: Vector3 = Vector3.ZERO) -> NPC:
	var npc = NPC.create()
	npc.position = position
	add_child(npc)
	npcs.append(npc)
	return npc
