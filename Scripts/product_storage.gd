class_name ProductStorage
extends CSGBox3D

signal clicked(player: Player,  mouseButton: int)

@export var product: Product = null
@export var count: int = 0
@export var pop_sound: AudioStreamPlayer3D
@export var products_container: Node3D

var product_grid: Vector3 = Vector3.ZERO
var max_count: int = 0


# --------------------
# Lifecycle
# --------------------
func _ready():
	if product:
		set_product(product)
		if count > 0:
			fill_aisle()

func _process(delta: float) -> void:
	if !product:
		return
	
	if Input.is_action_pressed("plus"):
		add_one()
	elif Input.is_action_pressed("minus"):
		remove_one()

# --------------------
# Public methods
# --------------------

func _on_clicked(player: Player, mouseButton: int) -> void:
	if player.in_hands is not Box: 
		return
	
	if mouseButton == MOUSE_BUTTON_LEFT:	
		if !product || count == 0:
			set_product(player.in_hands.product)
		elif player.in_hands.product.name != product.name || player.in_hands.product_count <= 0:
			return
		player.in_hands.product_count -= 1
		add_one()
		pop_sound.play()
	elif mouseButton == MOUSE_BUTTON_RIGHT:
		if !product || count <= 0 || player.in_hands is not Box || player.in_hands.product.name != product.name:
			return
		player.in_hands.product_count += 1
		remove_one()
		pop_sound.play()

# --------------------
# Internal helpers
# --------------------
func set_product(p: Product):
	if !p:
		return
	
	p.load()
	product = p
	calc_grid()
	count = clamp(count, 0, max_count)

func add_one():
	count = clamp(count + 1, 0, max_count)
	fill_aisle()

func remove_one():
	count = clamp(count - 1, 0, max_count)
	fill_aisle()

func calc_grid():
	product_grid = Vector3(
		int(size.x / product.width),
		int(size.y / product.height),
		int(size.z / product.depth)
	)
	max_count = product_grid.x * product_grid.y * product_grid.z

func fill_aisle():
	var delta = count - products_container.get_child_count()
	
	if delta < 0:
		remove_products(-delta)
	elif delta > 0:
		add_products(delta)

# --------------------
# Child management
# --------------------
func remove_products(amount: int):
	for i in range(amount):
		var last_child = products_container.get_child(-1)
		if !last_child: return
		last_child.queue_free()

func add_products(amount: int):
	var skip = products_container.get_child_count()
	for y in range(product_grid.y):
		for x in range(product_grid.x):
			for z in range(product_grid.z):
				if skip > 0:
					skip -= 1
					continue
				
				var prod_instance = product.create()
				prod_instance.position = -size/2 + product.size/2 + Vector3(
					x * product.width,
					y * product.height,
					z * product.depth
				)
				products_container.add_child(prod_instance)
				
				amount -= 1
				if amount == 0:
					return
