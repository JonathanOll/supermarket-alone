extends CharacterBody3D
class_name Player

@export var REACH = 10
@export var speed := 15.0
@export var mouse_sensitivity := 0.002
@export var camera: Camera3D
@export var hands: Node3D
@export var ray_length := 100.0  # longueur du rayon
@export var in_hands: Node3D

var yaw := 0.0
var pitch := 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(-89), deg_to_rad(89))

		camera.rotation.y = yaw
		camera.rotation.x = pitch

	handle_click(event)

	if event is InputEventKey and event.is_action_pressed("escape"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE \
							if (Input.mouse_mode == Input.MOUSE_MODE_CAPTURED) \
							else Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (camera.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	if not is_on_floor():
		velocity.y -= Global.gravity * delta
	elif Input.is_action_just_pressed("jump"):
		velocity.y = Global.gravity * 3/4

	move_and_slide()

func _shoot_raycast():
	var space_state = get_world_3d().direct_space_state
	var mousePos = get_viewport().get_mouse_position()
	
	var from = camera.project_ray_origin(mousePos)
	var to = from + camera.project_ray_normal(mousePos) * REACH
	var rayCaster = PhysicsRayQueryParameters3D.create(from, to)
	rayCaster.collide_with_areas = true
	rayCaster.collision_mask = Global.CLICKABLE | Global.HOLDABLE
	
	var result = space_state.intersect_ray(rayCaster)
	return result

func handle_click(event):
	if event is InputEventMouseButton:
		if event.pressed:
			var hit = _shoot_raycast()
			if hit:
				hit.collider.clicked.emit(self, event.button_index)
			else:
				if in_hands:
					clear_hand()

func get_in_hand(item):
	item.pick(hands)
	in_hands = item
					
func clear_hand():
	in_hands.drop(global_position + \
					camera.transform.basis * Vector3.FORWARD * REACH)
	in_hands = null
