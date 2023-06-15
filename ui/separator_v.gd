extends VBoxContainer

const HEIGHT = 0
const LINE_COLOR = Color.BLACK

func _ready():
	var spacer_top = Control.new()
	spacer_top.custom_minimum_size.y = HEIGHT / 2
	var line = ColorRect.new()
	line.custom_minimum_size.y = 1
	line.color = LINE_COLOR
	var spacer_bottom = Control.new()
	spacer_bottom.custom_minimum_size.y = HEIGHT / 2 - 1
	
	add_child(spacer_top)
	add_child(line)
	add_child(spacer_bottom)
