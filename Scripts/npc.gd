extends CharacterBody3D 
class_name NPC

static var scene: PackedScene = preload("res://Scenes/Entities/NPC.tscn")

func _ready() -> void:
	pass
	# TODO: créer une liste de course, pathfinding (entre rayons, a la caisse...)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= Global.gravity * delta
	move_and_slide()



static func create() -> NPC:
	return scene.instantiate()
