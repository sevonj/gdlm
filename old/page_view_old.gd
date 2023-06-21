extends Control

const PANEL_STYLE = preload("res://ui/res/stylebox_postcard.tres")
const FONT_TITLE = preload("res://ui/res/font/Vegur-Bold.otf")
const FONT_TITLE_SIZE = 32
const FONT_BODY = preload("res://ui/res/font/Vegur-Regular.otf")
const FONT_BODY_SIZE = 16
const FONT_META = preload("res://ui/res/font/Vegur-Regular.otf")
const FONT_META_SIZE = 12


@onready var post_title = Label.new()
@onready var post_body = Label.new()
@onready var post_image = TextureRect.new()
@onready var post_time = Label.new()
@onready var post_author = Label.new()

@onready var request_post = HTTPRequest.new()
@onready var request_image = HTTPRequest.new()

func _ready():
	var but_back = Button.new()
	add_child(but_back)
	but_back.text = "Back"
	but_back.pressed.connect(self._close)
	
	#LemmyViewer.page_view = self
	add_child(request_post)
	add_child(request_image)
	
	add_theme_stylebox_override("panel", PANEL_STYLE)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var vbox = VBoxContainer.new()
	add_child(vbox)
	vbox.add_child(post_image)
	vbox.add_child(post_title)
	vbox.add_child(post_body)
	vbox.add_child(post_time)
	
	post_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	post_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	post_image.expand_mode = TextureRect.EXPAND_FIT_HEIGHT_PROPORTIONAL
	post_title.add_theme_font_override("font", FONT_TITLE)
	post_title.add_theme_font_size_override("font_size", FONT_TITLE_SIZE)
	post_body.add_theme_font_override("font", FONT_BODY)
	post_body.add_theme_font_size_override("font_size", FONT_BODY_SIZE)
	post_time.add_theme_font_override("font", FONT_META)
	post_time.add_theme_font_size_override("font_size", FONT_META_SIZE)
	
	request_post.request_completed.connect(self._load_post)
	Requester.received_page.connect(self._load_post)

func get_page(id: String):
	Requester._get_page(id)

func _close():
	#LemmyViewer._close_post()
	post_image.texture = null
	post_body.text = ""
	post_title.text = ""

func _load_post(json):
	post_image.texture = null
	post_body.text = ""
	if json.has("image"):
		get_image(json.image.url)
	post_title.text = json.name
	if json.has("source"):
		post_body.text = json.source.content
#	post_time.text = json.published

func get_image(url: String):
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self._http_request_completed)
	var err = http_request.request(url)
	if err != OK:
		print("Failed requesting image")
		
	

func _http_request_completed(result, response_code, headers, body):
	var image = Image.new()
	
	var err = image.load_png_from_buffer(body)
	if err == OK:
		post_image.texture = ImageTexture.create_from_image(image)
		return
	
	err = image.load_jpg_from_buffer(body)
	if err == OK:
		post_image.texture = ImageTexture.create_from_image(image)
		return
	
	print("Failed opening image")
	
