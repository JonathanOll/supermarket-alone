extends Node3D
class_name Game

static var instance: Game

@export var player: Player
@export var level: Level
@export var shop: Shop
@export var npc_spawn_area: CSGBox3D

var money: Observable = Observable.new(1000)

func _init() -> void:
	assert(instance == null) # pr le singleton
	instance = self

func _ready() -> void:
	level.init()
	
	if Global.dev:
		var npc = level.add_npc(Vector3(10, 0, 0))
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta):
	if Input.is_action_just_pressed("dev"):
		shop.toggle()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("escape"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE \
								if (Input.mouse_mode == Input.MOUSE_MODE_CAPTURED) \
								else Input.MOUSE_MODE_CAPTURED
		elif event.is_action_pressed("alt"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif event.is_action_released("alt"):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func random_npc_spawn_location():
	var size = npc_spawn_area.size
	return npc_spawn_area.global_position + Vector3(
		randf_range(-size.x/2, size.x/2,),
		0,
		randf_range(-size.z/2, size.z/2,),
	)

func _on_npc_spawn_timeout() -> void:
	level.add_npc(random_npc_spawn_location())
