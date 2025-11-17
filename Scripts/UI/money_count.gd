extends Control
class_name MoneyCount

@export var label: Label

func _ready() -> void:
	Game.instance.money.observe(update)

func update(old, new):
	label.text = "%.2f$" % new
	
