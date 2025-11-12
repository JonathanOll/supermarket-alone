extends CharacterBody3D 
class_name NPC

@export var agent: NavigationAgent3D
@export var SPEED = 10

static var scene: PackedScene = preload("res://Scenes/Entities/NPC.tscn")

func _ready() -> void:
	pass
	# TODO: créer une liste de course, pathfinding (entre rayons, a la caisse...)

func _physics_process(delta: float) -> void:
	velocity.x = 0
	velocity.z = 0
	if not is_on_floor():
		velocity.y -= Global.gravity * delta
	if !agent.is_target_reached():
		follow_path()
	
	move_and_slide()

func go_to(pos: Vector3):
	agent.target_position = pos

func follow_path():
	var pos = agent.get_next_path_position()
	var dir = (pos - global_position).normalized()
	velocity.x = dir.x * SPEED
	velocity.z = dir.z * SPEED

static func create() -> NPC:
	return scene.instantiate()

	
