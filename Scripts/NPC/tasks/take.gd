extends Task
class_name TakeTask

var product_storage: ProductStorage
var count: int

func _init(npc: NPC, ps: ProductStorage, c: int):
	super._init(npc)
	product_storage = ps
	count = c

func finished():
	return count <= 0

func loop():
	if count > 0:
		if product_storage.count == 0:
			npc.complain("No more " + product_storage.product.name + " in stock !")
			count = 0
			return
		product_storage.remove_one()
		npc.products.append(product_storage.product)
		count -= 1
		
		var look_at_pos = product_storage.global_position
		look_at_pos.y = 0
		npc.look_at(look_at_pos)
		npc.animate(npc.animations.interact)
		
		npc.cooldown.start(1)
