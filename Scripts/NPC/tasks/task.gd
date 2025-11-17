extends Resource
class_name Task

var npc: NPC

func _init(npc: NPC) -> void:
	self.npc = npc

func start() -> void:
	return

func finish() -> void:
	npc.cooldown.start(randf_range(0.3, 0.5))

func finished() -> bool:
	return true

func loop() -> void:
	return
