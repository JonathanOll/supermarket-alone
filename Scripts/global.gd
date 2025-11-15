extends Node
# class_name déclaré dans le autoload

var gravity := 20

var TERRAIN := 1 << 0
var ENTITIES := 1 << 1
var CLICKABLE := 1 << 2
var HOLDABLE := 1 << 3
var HOVERABLE := 1 << 4

var products: Array[Product] = []

func _ready() -> void:
	for file in ResourceLoader.list_directory("res://Products/"):
		var product: Product = ResourceLoader.load("res://Products/" + file)
		await product.load(get_tree())
		products.push_back(product)


func is_on_layer(node: Node3D, layer_mask: int) -> bool:
	if not node.has_method("get_collision_layer"):
		return false
	return node.get_collision_layer() & layer_mask != 0
