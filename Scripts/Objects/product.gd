extends Resource
class_name Product

@export_subgroup("General")
@export var name: String
@export var unit_price: float = 1
@export var unit_per_box: int = 12

@export_subgroup("Model")
@export var model: PackedScene
@export var rotation: Vector3 = Vector3.ZERO
@export var translate: Vector3 = Vector3.ZERO

@export_subgroup("Aisle")
@export var gap: float = 0.05

var width: float 
var height: float 
var depth: float 
var size: Vector3

var image_texture: ImageTexture

func load(scene: SceneTree = null) -> void:
	calculate_bounds()
	create_image(scene)

func calculate_bounds():
	var model_instance = model.instantiate()
	
	var mesh_instance: MeshInstance3D
	for child in model_instance.get_children():
		if child is MeshInstance3D:
			mesh_instance = child
			break

	if mesh_instance:
		var aabb: AABB =  mesh_instance.get_aabb() * Transform3D(Basis.from_euler(rotation), Vector3.ZERO)
		
		width = aabb.size.z + gap
		height = aabb.size.y
		depth = aabb.size.x + gap
		size = Vector3(width, height, depth)

func create_image(scene: SceneTree):
	if !scene:
		return
	
	var subviewport = SubViewport.new()
	subviewport.size = Vector2(256, 256)
	subviewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	subviewport.own_world_3d = true
	
	var node = Node3D.new()
	subviewport.add_child(node)
	
	var camera = Camera3D.new()
	camera.position.x = 1.5
	camera.rotation.y = PI/2
	node.add_child(camera)
	
	var light = DirectionalLight3D.new()
	light.position.x = 0.75
	light.rotation.y = PI/2
	node.add_child(light)
	
	var model = create()
	subviewport.add_child(model)
	scene.current_scene.add_child(subviewport)
	
	# on attend que le subviewport soit en place et ait généré une image
	await scene.process_frame
	await scene.process_frame
	
	var img = subviewport.get_viewport().get_texture().get_image()
	image_texture = ImageTexture.create_from_image(img)
	
	subviewport.queue_free()


func create():
	var instance: Node3D = model.instantiate()
	instance.transform = Transform3D(Basis.from_euler(rotation), Vector3.ZERO)
	return instance
