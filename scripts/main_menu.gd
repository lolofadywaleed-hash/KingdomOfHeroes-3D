extends Control

func _ready() -> void:
var bg := ColorRect.new()
bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
bg.color = Color("10152b")
add_child(bg)
var glow := ColorRect.new()
glow.color = Color("26385c")
glow.position = Vector2(0, 0)
glow.size = Vector2(1280, 310)
add_child(glow)
var center := VBoxContainer.new()
center.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
center.position = Vector2(-350, -155)
center.size = Vector2(700, 310)
center.add_theme_constant_override("separation", 32)
add_child(center)
var title := Label.new()
title.text = "مغامرات الأبطال الثلاثة"
title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
title.add_theme_font_size_override("font_size", 54)
title.add_theme_color_override("font_color", Color("f4d88a"))
center.add_child(title)
var subtitle := Label.new()
subtitle.text = "رحلة سحرية تبدأ من هنا"
subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
subtitle.add_theme_font_size_override("font_size", 24)
center.add_child(subtitle)
var button := Button.new()
button.text = "العب الآن"
button.custom_minimum_size = Vector2(300, 72)
button.add_theme_font_size_override("font_size", 28)
center.add_child(button)
button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/hero_select.tscn"))
