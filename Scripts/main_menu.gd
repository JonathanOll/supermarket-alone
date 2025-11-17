extends Control
class_name MainMenu

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
