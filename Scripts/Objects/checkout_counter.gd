extends Node3D
class_name CheckoutCounter

@export var productContainer: MixedProductStorage
@export var sound: AudioStreamPlayer3D
@export var price_label: Label3D
@export var queue_start: Node3D
@export var queue2: Node3D
@export var bills_container: Node3D

var total_price: float = 0
var paid: float = 0
var queue: Array[NPC] = []

static var scene: PackedScene = preload("res://Scenes/Objects/CheckoutCounter.tscn")

func _ready():
	update_label()
	init_bills()

func _on_products_clicked(player: Player, mouseButton: int) -> void:
	if productContainer.hasProducts():
		total_price += productContainer.remove_last_item().unit_price
		update_label()
		sound.play()
		if !productContainer.hasProducts() && current_customer().products.is_empty():
			var overpaid = int(total_price * randf_range(0, 0.5))
			paid = total_price + overpaid
			if overpaid == 0:
				next_customer()
			update_label()

func update_label():
	price_label.text = "TOTAL: %0.2f€\nPAID: %0.2f€\nDUE: %0.2f€" % [total_price, paid, max(0, paid - total_price)]

# retourne la position de la n-ieme place de la file d'attente
func queue_position(n: int = -1) -> Vector3:
	if n == -1:
		n = queue.size()
	var delta = queue2.global_position - queue_start.global_position
	return queue_start.global_position + delta * n

func add_to_queue(npc: NPC) -> int:
	queue.append(npc)
	return queue.size() - 1

func customer_position(npc: NPC) -> int:
	return queue.find(npc)

func current_customer() -> NPC:
	return queue[0] if !queue.is_empty() else null

func add_item(product: Product) -> void:
	productContainer.add_item(product)

func init_bills():
	for c in bills_container.get_children():
		var bill = c as Bill
		c.add.connect(give_back_money)

func give_back_money(value: int):
	if !current_customer():
		return
	
	paid -= value
	Game.instance.money.set_value(Game.instance.money.get_value() - value)
	update_label()
	if paid <= total_price:
		next_customer()

func next_customer():
	paid = 0
	total_price = 0
	
	var cur = queue.pop_front()
	if (cur && cur.current_task is CheckoutTask):
		(cur.current_task as CheckoutTask).done = true


static func create():
	return scene.instantiate()
