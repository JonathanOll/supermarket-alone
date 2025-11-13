extends CharacterBody3D 
class_name NPC

static var scene: PackedScene = preload("res://Scenes/Entities/NPC.tscn")

@export var agent: NavigationAgent3D
@export var SPEED = 10

var products: Array[Product] = []
var tasks: Array[Task] = []
var current_task: Task

func _ready() -> void:
	var product_count = randi_range(1, 3)
	for i in range(product_count):
		var aisle = Game.game.aisles.pick_random()
		var storage = aisle.products_storages.pick_random()
		tasks.append(GotoTask.new(storage.front.global_position))
		tasks.append(TakeTask.new(storage, randi_range(0, min(5, storage.count))))
	next_task()
	# TODO: le faire aller à la caisse pour attendre

func _physics_process(delta: float) -> void:
	velocity.x = 0
	velocity.z = 0
	if not is_on_floor():
		velocity.y -= Global.gravity * delta
	if !agent.is_target_reached():
		follow_path()
	elif current_task is GotoTask:
		next_task()
		
	move_and_slide()

func go_to(pos: Vector3):
	pos.y = 0
	agent.target_position = pos

func follow_path():
	var pos = agent.get_next_path_position()
	var dir = (pos - global_position).normalized()
	velocity.x = dir.x * SPEED
	velocity.z = dir.z * SPEED
	
	# regarder dans la bonne direction
	dir.y = 0
	if dir.length_squared() > 0.001:
		var look_at_position = global_position + dir
		look_at(look_at_position)

func next_task():
	if tasks.is_empty():
		return
	current_task = tasks.pop_front()
	if current_task is GotoTask:
		go_to((current_task as GotoTask).position)
	elif current_task is TakeTask:
		for i in range((current_task as TakeTask).count):
			products.append((current_task as TakeTask).product_storage.product)
			(current_task as TakeTask).product_storage.remove_one()
		next_task()


static func create() -> NPC:
	return scene.instantiate()

	
