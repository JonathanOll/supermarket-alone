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

func _process(delta):
	if Input.is_action_just_pressed("dev"):
		shop.visible = !shop.visible

	
