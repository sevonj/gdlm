extends VBoxContainer

const POST_LISTING = preload("res://ui/post_listing.gd")
const POST_SEPARATOR = preload("res://ui/separator_v.gd")

@onready var post_list = $post_list

signal opened_post(id: String)

func _ready():
	LemmyViewer.feed_view = self
	opened_post.connect(LemmyViewer._open_post)
	Requester.received_outbox.connect(self.update_feed)
	
	$toolbar/input_refreshbut.pressed.connect(_refresh)
	$toolbar/input_url.text_changed.connect(Globals._set_current_community)

func clear_post_list():
	for child in post_list.get_children():
		child.queue_free()

func update_feed(json):
	clear_post_list()
	
	for post in json.orderedItems:
		var post_listing = POST_LISTING.new()
		post_list.add_child(post_listing)
		post_listing._load_post(post)
		post_listing.connect("opened", self._opened_post)
		post_list.add_child(POST_SEPARATOR.new())


func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		_refresh()

func _refresh():
	clear_post_list()
	Requester._get_group(Globals.current_community)

# This is called by post_listing nodes
func _opened_post(id: String):
	emit_signal("opened_post", id)
