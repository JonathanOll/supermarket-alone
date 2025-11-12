extends RigidBody3D
class_name Box

@export var product: Product
@export var img_generator: Node3D
@export var viewport: SubViewport
@export var image_container: CSGBox3D
@export var collider: CollisionShape3D
@export var model: Node3D
@export var product_count: int

static var scene: PackedScene = preload("res://Scenes/Objects/Box.tscn")

func _ready() -> void:
	if !product: return
	
	product.load()
	img_generator.add_child(product.create())

func _on_timer_timeout() -> void:
	if !product: return
	
	var img = viewport.get_viewport().get_texture().get_image()
	
	var mat = StandardMaterial3D.new()
	mat.albedo_texture = ImageTexture.create_from_image(img)
	image_container.material = mat
	
func pick(node: Node3D):
	model.get_parent().remove_child(model)
	node.add_child(model)
	toggle(false)

func drop(pos: Vector3):
	model.get_parent().remove_child(model)
	add_child(model)
	global_position = pos
	toggle(true)
	rotation = Vector3.ZERO

func toggle(value: bool) -> void:
	visible = value
	if !value:
		model.position = Vector3.ZERO
		
static func create(product: Product) -> Box:
	var instance: Box = scene.instantiate()
	instance.product = product
	instance.product_count = product.unit_per_box
	return instance
