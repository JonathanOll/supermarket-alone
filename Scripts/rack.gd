extends Node3D
class_name Rack

@export var box_storages: Array[BoxStorage] = []

static var scene: PackedScene = preload("res://Scenes/Objects/Rack.tscn")

static func create() -> Rack:
	return scene.instantiate()
