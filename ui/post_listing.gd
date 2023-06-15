extends PanelContainer

const MIN_SIZE = Vector2(0,60)
const THUMBNAIL_SIZE = Vector2(120,120)

@onready var post_thumbnail = TextureRect.new()
@onready var post_title = Label.new()
@onready var post_summary = Label.new()

@onready var request_thumbnail = HTTPRequest.new()

var post_url: String

signal opened(id: String)

func _ready():
	add_theme_stylebox_override("panel", Globals.UI_STYLEBOX_POSTCARD)
	custom_minimum_size = MIN_SIZE
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	mouse_entered.connect(self._on_mouse_entered)
	mouse_exited.connect(self._on_mouse_exited)
	self_modulate = Color.TRANSPARENT
	
	var hbox = HBoxContainer.new()
	var vbox = VBoxContainer.new()
	var vote_box = MarginContainer.new()
	vote_box.custom_minimum_size.x = 32
	add_child(hbox)
	hbox.add_child(vote_box)
	hbox.add_child(post_thumbnail)
	hbox.add_child(vbox)
	vbox.add_child(post_title)
	vbox.add_child(post_summary)
	
	post_thumbnail.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	post_thumbnail.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	post_thumbnail.custom_minimum_size = THUMBNAIL_SIZE

func _load_post(data):
	if data == null:
		return
	if !data.has("object"):
		return
	if !data.object.has("object"):
		return
	post_title.text = data.object.object.name
	post_thumbnail.texture = Globals.UI_DEFAULT_IMG
	if data.object.object.has("image"):
		get_image(data.object.object.image.url)
	post_url = data.object.object.id

func get_image(url: String):
	add_child(request_thumbnail)
	request_thumbnail.connect("request_completed", self.request_thumbnail_completed)
	var err = request_thumbnail.request(url)
	if err != OK:
		print("Failed requesting image")

func request_thumbnail_completed(result, response_code, headers, body):
	if result != 0:
		return
	
	# Try various image formats
	var image = Image.new()
	if image.load_png_from_buffer(body) == OK:
		post_thumbnail.texture = ImageTexture.create_from_image(image)
		return
	if image.load_jpg_from_buffer(body) == OK:
		post_thumbnail.texture = ImageTexture.create_from_image(image)
		return
	
	print("Failed opening image")

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			emit_signal("opened", post_url)
			#print("clicked: ", post_url)

func _on_mouse_entered():
	self_modulate = Color.BLACK
func _on_mouse_exited():
	self_modulate = Color.TRANSPARENT
