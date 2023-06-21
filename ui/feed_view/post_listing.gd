extends PanelContainer

@onready var post_title = $hbox/vbox/post_title
@onready var post_thumb = $hbox/post_thumb
@onready var post_meta = $hbox/vbox/cont_meta/post_meta

var post_url: String

signal opened(url)

func _ready():
	post_title.theme = Globals.FONT_THEME_POSTCARD_TITLE
	post_meta.theme = Globals.FONT_THEME_META

func _load_post(data: Dictionary):
	post_url = data.object.object.id
	
	post_title.text = data.object.object.name
	
	var meta_text = ""
	meta_text += DataHelper.get_full_username(data.object.actor)
	meta_text += " to "
	meta_text += DataHelper.get_community_name(data.actor)
	meta_text += " • "
	#meta_text += str(2) + " Comments"
	#meta_text += " • "
	meta_text += DataHelper.get_time_since(data.object.object.published)
	post_meta.text = meta_text
	
	if "image" in data.object.object:
		post_thumb.texture = await DataHelper.get_image(data.object.object.image.url)

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			emit_signal("opened", post_url)
