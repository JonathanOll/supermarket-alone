class_name MixedProductStorage
extends CSGBox3D

@export var products: Array[Product] = []
@export var products_container: Node3D
@export var GAP: float = 0.1
@export var sound: AudioStreamPlayer3D

func interact(player: Player, mouseButton: int = MOUSE_BUTTON_LEFT):
	if products.size() > 0:
		products.pop_back()
		products_container.remove_child(products_container.get_child(-1))
		sound.play()


func _ready():
	var x = 0
	for p in products:
		p.load()
		var product = p.create()
		product.position = size/2 - p.size/2
		product.position.y = -size.y/2 + p.size.y/2
		product.position.x -= x
		x += p.width + GAP
		products_container.add_child(product)

		
