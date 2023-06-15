extends Control

const HEADERS = ["Accept: application/json"]
const POSTVIEW = preload("res://page_view.gd")

@onready var sidebar = VBoxContainer.new()
@onready var post_view = POSTVIEW.new()

var community_url = "https://suppo.fi/c/photogrammetry/outbox"

func _ready():
	
	var scroll = create_scroll()
	var toolbar = HBoxContainer.new()
	toolbar.custom_minimum_size.y = 20
	var bottom_spacer = Control.new()
	bottom_spacer.custom_minimum_size.y = 60
	var vbox = VBoxContainer.new()
	var hbox = HBoxContainer.new()
	scroll.anchor_bottom = 1
	scroll.anchor_right = 1
	#scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	#scroll.mouse_filter = Control.MOUSE_FILTER_PASS
	#hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#bottom_spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	
	add_child(scroll)
	scroll.add_child(vbox)
	vbox.add_child(toolbar)
	vbox.add_child(hbox)
	vbox.add_child(bottom_spacer)
	hbox.add_child(create_spacer())
	hbox.add_child(post_view)
	hbox.add_child(create_spacer())
	
	sidebar.custom_minimum_size.x = 256
	post_view.custom_minimum_size.x = 600
	
	var sidebar_parent = Control.new()
	sidebar_parent.add_child(sidebar)
	add_child(sidebar_parent)
	sidebar.position.y = 96
	sidebar.clip_contents = true
	sidebar.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	
	var input_fetch = Button.new()
	input_fetch.text = "Refresh"
	#input_fetch.connect("pressed", self.request_feed)
	input_fetch.pressed.connect(Requester._get_outbox.bind(community_url))
	
	var input_url = LineEdit.new()
	input_url.text = community_url
	input_url.connect("text_changed", self._change_url)
	input_url.position.y = 30
	input_url.size.x = 256
	
	sidebar_parent.add_child(input_url)
	sidebar_parent.add_child(input_fetch)
	
	Requester.received_outbox.connect(self.update_feed)
	

func _process(delta):
	return
	if Input.is_action_just_pressed("ui_accept"):
		pass
	if Input.is_action_just_pressed("ui_end"):
		pass

func _change_url(url):
	community_url = url



func update_feed(json):
	for child in sidebar.get_children():
		child.queue_free()
	
	for post in json.orderedItems:
		var post_name = post.object.object.name
		var post_url = post.object.object.id
		var button = Button.new()
		button.text = post_name
		button.text_overrun_behavior = TextServer.OVERRUN_TRIM_CHAR
		#var req_action = self.request_post.bind(post_url)
		#button.connect("pressed", req_action)
		sidebar.add_child(button)
		print(post_name, " ", post_url)

func create_spacer():
	var spacer = Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return spacer

func create_scroll():
	var scroll = ScrollContainer.new()
	scroll.horizontal_scroll_mode = 0
	return scroll
