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

func load() -> void:
	var model_instance = model.instantiate()
	
	var mesh_instance: MeshInstance3D
	for child in model_instance.get_children():
		if child is MeshInstance3D:
			mesh_instance = child
			break
	
	if mesh_instance:
		var aabb: AABB =  mesh_instance.get_aabb() * Transform3D(Basis().from_euler(rotation), Vector3.ZERO)
		
		width = aabb.size.z + gap
		height = aabb.size.y
		depth = aabb.size.x + gap
		size = Vector3(width, height, depth)

func create():
	var instance: Node3D = model.instantiate()
	instance.transform = Transform3D(Basis().from_euler(rotation), Vector3.ZERO)
	return instance
