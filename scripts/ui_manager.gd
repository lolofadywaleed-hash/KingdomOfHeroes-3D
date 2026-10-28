extends Control

func _ready():
	var play_button = get_node_or_null("PlayButton")
	if play_button:
		play_button.pressed.connect(_on_play_pressed)
	
	var buttons = get_tree().get_nodes_in_group("hero_buttons")
	for btn in buttons:
		btn.pressed.connect(_on_hero_selected.bind(btn.name))
	
	# Also connect buttons directly
	for child in get_children():
		if child is Button and child.name == "PlayButton":
			if not child.pressed.is_connected(_on_play_pressed):
				child.pressed.connect(_on_play_pressed)
	
	# Connect hero select buttons
	var heroes_container = get_node_or_null("HeroesContainer")
	if heroes_container:
		for hero_panel in heroes_container.get_children():
			if hero_panel.has_node("SelectBtn"):
				var btn = hero_panel.get_node("SelectBtn")
				if not btn.pressed.is_connected(_on_hero_selected):
					btn.pressed.connect(_on_hero_selected.bind(hero_panel.name))

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/hero_select.tscn")

func _on_hero_selected(hero_name):
	# Store selected hero
	Global.selected_hero = hero_name
	get_tree().change_scene_to_file("res://scenes/game.tscn")
