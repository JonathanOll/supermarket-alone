extends ExtendedCharacter
class_name NPC

static var scene: PackedScene = preload("res://Scenes/Entities/NPC.tscn")

var slurs = [
	"Your brain must be stuck in airplane mode.",
	"You're the type who loses to a tutorial.",
	"I'm pretty sure you study with coloring books.",
	"Your Wi-Fi is more stable than your arguments.",
	"You've got the logic of a toaster on strike.",
	"Looks like you do math using pebbles.",
	"Your charisma is running on power-saving mode.",
	"Even Google refuses to answer you.",
	"You’ve got the comeback skills of a goldfish in a meeting.",
	"Feels like you store your ideas on a floppy disk."
]

var animations = {
	walk = {
		res = "CharacterArmature|Walk",
		loop = true
	},
	interact = {
		res = "CharacterArmature|Interact",
		loop = false
	},
	idle = {
		res = "CharacterArmature|Idle",
		loop = true
	},
	hit = {
		res = "CharacterArmature|HitRecieve_2",
		loop = false
	}
}

@export var cooldown: Timer
@export var agent: NavigationAgent3D
@export var SPEED := randi_range(7, 13)
@export var complaint_label: Label3D
@export var complaint_timer: Timer
@export var models: Array[PackedScene] = []
@export var punch: AudioStreamPlayer3D

var products: Array[Product] = []
var tasks: Array[Task] = []
var current_task: Task

var animation_player: AnimationPlayer


func _ready() -> void:
	init_model()
	init_animations()
	init_behavior()
	
func _physics_process(delta: float) -> void:
	velocity.x = 0
	velocity.z = 0
	if not is_on_floor():
		velocity.y -= Global.gravity * delta
		
	handle_tasks()
	
	move_and_slide()

func next_task():
	current_task = tasks.pop_front()
	current_task.start()

func init_behavior():
	var product_count = randi_range(1, 3)
	for i in range(product_count):
		var aisle = Game.instance.level.aisles.pick_random()
		var storage = aisle.products_storages.pick_random()
		tasks.append(GotoTask.new(self, storage.front.global_position))
		tasks.append(TakeTask.new(self, storage, randi_range(0, min(5, storage.count))))
	tasks.append(CheckoutTask.new(self, Game.instance.level.checkout_counters.pick_random()))
	# TODO: le faire aller à la caisse pour attendre

func init_model():
	var model: Node3D = models.pick_random().instantiate()
	model.rotation.y = PI
	model.scale *= randf_range(3.2,3.8)
	for child in model.get_children():
		if child is AnimationPlayer:
			animation_player = child
			break
	add_child(model)

func init_animations():
	for animation in animations.values():
		animation_player.get_animation(animation.res).loop_mode = \
			Animation.LOOP_LINEAR if animation.loop else Animation.LOOP_NONE
	animate(animations.idle)

func animate(animation):
	animation_player.play(animation.res)

func handle_tasks():
	if !cooldown.is_stopped():
		return
		
	if current_task:
		current_task.loop()
		if current_task.finished() && !tasks.is_empty():
			next_task()
	elif !tasks.is_empty():
		next_task()

func complain(text: String, duration: float = 5.0):
	complaint_label.text = text
	complaint_timer.start(duration)	

func receive_hit():
	animate(animations.hit)
	velocity.x = 0
	velocity.z = 0
	cooldown.start(2)
	complain(slurs.pick_random())
	punch.play()

func _on_complaint_timer_timeout() -> void:
	complaint_label.text = ""

func _on_clicked(player: Player, mouseButton: int) -> void:
	receive_hit()
	var look_at_pos = player.global_position
	look_at_pos.y = 0
	look_at(look_at_pos)


static func create() -> NPC:
	return scene.instantiate()

	
