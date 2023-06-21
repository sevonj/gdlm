extends VBoxContainer

const HEIGHT = 0

func _ready():
	var spacer_top = Control.new()
	spacer_top.custom_minimum_size.y = HEIGHT / 2
	var line = ColorRect.new()
	line.custom_minimum_size.y = 1
	line.color = Color.from_string("303030", Color.DARK_RED)
	var spacer_bottom = Control.new()
	spacer_bottom.custom_minimum_size.y = HEIGHT / 2 - 1
	
	add_child(spacer_top)
	add_child(line)
	add_child(spacer_bottom)
