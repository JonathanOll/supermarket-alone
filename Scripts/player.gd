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

var last_hovered = null

func _input(event):
	if event is InputEventScreenDrag || event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(-89), deg_to_rad(89))

		camera.rotation.y = yaw
		camera.rotation.x = pitch
	

	handle_click(event)

func _process(_delta):
	for button in [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_RIGHT]:
		if Input.is_mouse_button_pressed(button):
			var hit = _shoot_raycast(Global.HOLDABLE)
			if hit:
				hit.collider.hold.emit(self, button)
	
	var hit = _shoot_raycast(Global.HOVERABLE)
	if last_hovered && (!hit || last_hovered != hit.collider):
		last_hovered.unhovered.emit(self)
	if hit:
		hit.collider.hovered.emit(self)
		last_hovered = hit.collider
	
				
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

func handle_click(event):
	if (event is InputEventScreenTouch || event is InputEventMouseButton) && event.pressed:
		var hit = _shoot_raycast(Global.CLICKABLE, event.position)
		if hit:
			hit.collider.clicked.emit(self, event.button_index if event is InputEventMouseButton else MOUSE_BUTTON_LEFT)

func get_in_hand(item) -> void:
	item.pick(hands)
	in_hands = item
					
func clear_hand():
	in_hands.drop(global_position + \
					camera.transform.basis * Vector3.FORWARD * REACH)
	in_hands = null


func _shoot_raycast(mask: int, screen_position: Vector2 = Vector2(-1000,-1000)):
	var space_state = get_world_3d().direct_space_state
	if screen_position.x == screen_position.y and screen_position.x == - 1000:
		screen_position = get_viewport().size / 2
	
	var from = camera.project_ray_origin(screen_position)
	var to = from + camera.project_ray_normal(screen_position) * REACH
	var rayCaster = PhysicsRayQueryParameters3D.create(from, to)
	rayCaster.collide_with_areas = true
	rayCaster.collision_mask = mask
	
	var result = space_state.intersect_ray(rayCaster)
	return result
