extends Control
class_name BuyableProduct

static var scene: PackedScene = preload("res://UI/Shop/BuyableProduct.tscn")

var product: Product

@export var image: Panel

@export var name_label: Label
@export var quantity_label: Label
@export var price_label: Label

static func create(product: Product) -> BuyableProduct:
	var instance = scene.instantiate()
	instance.product = product
	
	instance.name_label.text = product.name
	instance.quantity_label.text = "Quantity: " + str(product.unit_per_box)
	instance.price_label.text = str(product.unit_price * product.unit_per_box) + "$"
	
	var stylebox = StyleBoxTexture.new()
	stylebox.texture = product.image_texture
	instance.image.add_theme_stylebox_override("panel", stylebox)
	
	return instance
