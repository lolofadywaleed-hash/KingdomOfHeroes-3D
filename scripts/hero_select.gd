extends Control
const HEROES = [{"id":"lulu","name":"لولو","color":Color("58d68d"),"icon":"🍃"},{"id":"fadi","name":"فادي","color":Color("f06454"),"icon":"🔥"},{"id":"alsayed","name":"السيد","color":Color("55b8ee"),"icon":"💧"}]
func _ready() -> void:
var bg := ColorRect.new(); bg.color = Color("10152b"); bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); add_child(bg)
var root := VBoxContainer.new(); root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); root.add_theme_constant_override("separation", 18); root.add_theme_constant_override("margin_left", 60); root.add_theme_constant_override("margin_right", 60); root.add_theme_constant_override("margin_top", 38); root.add_theme_constant_override("margin_bottom", 38); add_child(root)
var title := Label.new(); title.text="اختر بطلك"; title.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER; title.add_theme_font_size_override("font_size",42); title.add_theme_color_override("font_color",Color("f4d88a")); root.add_child(title)
var row := HBoxContainer.new(); row.size_flags_vertical=Control.SIZE_EXPAND_FILL; row.add_theme_constant_override("separation",24); root.add_child(row)
for hero in HEROES:
var panel := PanelContainer.new(); panel.size_flags_horizontal=Control.SIZE_EXPAND_FILL; row.add_child(panel)
var box := VBoxContainer.new(); box.alignment=BoxContainer.ALIGNMENT_CENTER; box.add_theme_constant_override("separation",16); panel.add_child(box)
var emblem := Label.new(); emblem.text=hero.icon; emblem.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER; emblem.add_theme_font_size_override("font_size",70); box.add_child(emblem)
var name := Label.new(); name.text=hero.name; name.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER; name.add_theme_font_size_override("font_size",32); name.add_theme_color_override("font_color",hero.color); box.add_child(name)
var desc := Label.new(); desc.text="بطل شجاع من الغابة السحرية"; desc.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER; box.add_child(desc)
var btn := Button.new(); btn.text="اختيار"; btn.custom_minimum_size=Vector2(0,58); box.add_child(btn)
btn.pressed.connect(func(): get_tree().set_meta("selected_hero",hero.id); get_tree().change_scene_to_file("res://scenes/game.tscn"))
var back := Button.new(); back.text="رجوع"; back.custom_minimum_size=Vector2(140,50); root.add_child(back); back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/main_menu.tscn"))
