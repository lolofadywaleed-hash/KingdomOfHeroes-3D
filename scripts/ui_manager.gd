extends Node

func open_hero_select() -> void:
get_tree().change_scene_to_file("res://scenes/hero_select.tscn")

func start_game(hero_id: String) -> void:
get_tree().set_meta("selected_hero", hero_id)
get_tree().change_scene_to_file("res://scenes/game.tscn")
