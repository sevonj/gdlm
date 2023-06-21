extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	_set_style()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _set_style():
	$cont_body/body.theme = Globals.FONT_THEME_BODY
	$cont_meta/dot1.theme = Globals.FONT_THEME_META
	$cont_meta/author.theme = Globals.FONT_THEME_META
	$cont_meta/time.theme = Globals.FONT_THEME_META
