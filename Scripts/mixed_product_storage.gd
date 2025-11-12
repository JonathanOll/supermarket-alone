class_name MixedProductStorage
extends CSGBox3D

signal clicked(player: Player,  mouseButton: int)

@export var products: Array[Product] = []
@export var products_container: Node3D
@export var GAP: float = 0.1

func _ready() -> void:
	refresh()

func refresh() -> void:
	for child in products_container.get_children():
		products_container.remove_child(child)
		
	var x = 0
	var z = 0
	var max_z = 0
	for p in products:
		p.load()
		var product = p.create()
		if x > size.x:
			x = 0
			z += max_z + GAP
			max_z = 0
		
		product.position = size/2 - p.size/2
		product.position.y = -size.y/2 + p.size.y/2
		product.position.x -= x
		product.position.z -= z
		x += p.width + GAP
		
		if p.depth > max_z: 
			max_z = p.depth
		products_container.add_child(product)

func remove_last_item():
	products_container.remove_child(products_container.get_child(-1))
	return products.pop_back()

func add_item(p: Product):
	p.load()
	products.push_back(p)
	products_container.add_child(p.create())
	refresh()
	
func hasProducts() -> bool:
	return !products.is_empty()
