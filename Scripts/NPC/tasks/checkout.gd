extends Task
class_name CheckoutTask

var checkout_counter: CheckoutCounter
var done: bool = false

func _init(npc: NPC, cc: CheckoutCounter):
	super._init(npc)
	checkout_counter = cc

func start():
	if npc.products.is_empty():
		done = true
		return
	var pos = checkout_counter.add_to_queue(npc)
	npc.agent.target_position = checkout_counter.queue_position(pos)

func finish():
	super.finish()
	npc.complain(npc.goodbye.pick_random(), 2)

func finished():
	return done

func loop():
	if !npc.agent.is_target_reached():
		pathfind()
		return
	
	npc.animate(npc.animations.idle)
	
	if checkout_counter.current_customer() == npc && !npc.products.is_empty():
		put_item()
		

func pathfind():
	var pos = npc.agent.get_next_path_position()
	var dir = (pos - npc.global_position).normalized()
	npc.velocity.x = dir.x * npc.SPEED
	npc.velocity.z = dir.z * npc.SPEED
		
	#  animation + regarder dans la bonne direction
	dir.y = 0
	if dir.length_squared() > 0.001:
		var look_at_position = npc.global_position + dir
		npc.look_at(look_at_position)
		npc.animate(npc.animations.walk)

func put_item():
	var product = npc.products.pop_front()
	checkout_counter.add_item(product)
	
	var look_at_pos = checkout_counter.global_position
	look_at_pos.y = 0
	npc.look_at(look_at_pos)
	npc.animate(npc.animations.interact)
	
	npc.cooldown.start(1)
