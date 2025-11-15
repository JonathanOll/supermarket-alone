extends Node3D
class_name Game

static var instance: Game

@export var navigation_region: NavigationRegion3D
@export var player: Player
@export var level: Level
@export var shop: Shop

var money: float = 1_000

func _ready() -> void:
	assert(instance == null) # pr le singleton
	instance = self
	level.init()
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	level.add_npc(Vector3(40, 0, -10))

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


func _on_npc_spawn_timeout() -> void:
	level.add_npc(Vector3(40, 0, -10))
