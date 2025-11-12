extends Node
# class_name déclaré dans le autoload

var gravity := 20

var PICKABLE := 1 << 1
var STOCKAGE := 1 << 2

var products: Array[Product] = []

func _ready() -> void:
	for file in DirAccess.open("res://Products/").get_files():
		products.push_back(load("res://Products/" + file))


func is_on_layer(node: Node3D, layer_mask: int) -> bool:
	if not node.has_method("get_collision_layer"):
		return false
	return node.get_collision_layer() & layer_mask != 0
