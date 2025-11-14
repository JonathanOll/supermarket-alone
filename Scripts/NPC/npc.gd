extends ClickableCharacter
class_name NPC

static var scene: PackedScene = preload("res://Scenes/Entities/NPC.tscn")

var slurs = [
	"Ton cerveau doit avoir le mode avion activé.",
	"T’es le genre à perdre contre un tutoriel.",
	"Je suis sûr que tu révises avec des coloriages.",
	"Ton Wi-Fi est plus stable que tes arguments.",
	"T’as la logique d’un grille-pain en grève.",
	"On dirait que tu fais des calculs avec des cailloux.",
	"Ton charisme est en mode économie d’énergie.",
	"Même Google ne veut pas te répondre.",
	"T’as la répartie d’un poisson rouge en réunion.",
	"On dirait que tu sauvegardes tes idées sur une disquette."
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
@export var SPEED = 10
@export var animation_player: AnimationPlayer
@export var complaint_label: Label3D
@export var complaint_timer: Timer

var products: Array[Product] = []
var tasks: Array[Task] = []
var current_task: Task

func _ready() -> void:
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

func _on_complaint_timer_timeout() -> void:
	complaint_label.text = ""

func _on_clicked(player: Player, mouseButton: int) -> void:
	receive_hit()
	var look_at_pos = player.global_position
	look_at_pos.y = 0
	look_at(look_at_pos)


static func create() -> NPC:
	return scene.instantiate()

	
