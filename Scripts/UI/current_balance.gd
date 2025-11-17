extends Label


func update(old, new):
	text = "%.2f$" % new
	
func _ready() -> void:
	Game.instance.money.observe(update)
