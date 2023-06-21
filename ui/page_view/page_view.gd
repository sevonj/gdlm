extends VBoxContainer

const UI_COMMENT = preload("res://ui/page_view/ui_comment.tscn")
const UI_THREADLINE = preload("res://ui/page_view/ui_comment_threadline.tscn")

var comments_by_id: Dictionary

func _ready():
	UI.page_view = self
	$toolbar/input_back.pressed.connect(UI._close_page)
	_set_style()
	_clear_page()
	
func _load_page(base_url: String, post_id: int):
	_clear_page()
	await _load_post(base_url, post_id)
	await _load_comments(base_url, post_id)

func _clear_page():
	# Clear post
	$post/vbox/cont_media/post_img.hide()
	$post/vbox/cont_media/post_img.texture = Globals.UI_DEFAULT_IMG
	$post/vbox/cont_title/title.text = "..."
	$post/vbox/cont_body/body.text = "..."
	$post/vbox/cont_meta/row1/post_author.text = "author"
	$post/vbox/cont_meta/row1/post_community.text = "community"
	$post/vbox/cont_meta/row2/time.text = "0h"
	$post/vbox/cont_meta/row2/numcomments.text = str(0) + " Comments"
	
	# Clear comments
	for child in $comments.get_children():
		child.queue_free()

func _load_post(base_url: String, post_id: int):
	var params = {
		"id": post_id
	}
	var data = await ApiManager.GetPost(base_url, params)
	if data.is_empty():
		$post/vbox/cont_body/body.text = "Couldn't load post."
		return
	$post/vbox/cont_title/title.text = data.post_view.post.name
	$post/vbox/cont_body/body.text = data.post_view.post.body
	$post/vbox/cont_meta/row1/post_author.text = DataHelper.get_full_username(data.post_view.creator.actor_id)
	$post/vbox/cont_meta/row1/post_community.text = DataHelper.get_community_name(data.post_view.community.actor_id)
	$post/vbox/cont_meta/row2/time.text = DataHelper.get_time_since(data.post_view.post.published)
	$post/vbox/cont_meta/row2/numcomments.text = str(data.post_view.counts.comments) + " Comments"
	if data.post_view.post.url != null:
		$post/vbox/cont_media/post_img.show()
		_load_image(data.post_view.post.url)

func _load_image(url: String):
	$post/vbox/cont_media/post_img.texture = await DataHelper.get_image(url)

func _load_comments(base_url: String, post_id: int):
	var params = {
		"post_id": post_id,
		"limit": 500
	}
	var data = await ApiManager.GetComments(base_url, params)
	
	if !data.has("comments"):
		return
	
	comments_by_id = {}
	
	for comment in data.comments:
		var result = _create_comment(comment)
	
	for id in comments_by_id:
		var comment = comments_by_id[id]
		var parent_id = comment.get_meta("parent_id")
		if parent_id in comments_by_id:
			comments_by_id[parent_id].add_child(comment)
		elif parent_id == "0":
			$comments.add_child(comment)
		else:
			print("failed to get comment parent: ", id, ", ", parent_id)
	

	
func _create_comment(data):
	var comment_cont = VBoxContainer.new() # Parent of comment_box and all replies.
	var comment_box = HBoxContainer.new() # Parent of threadlines and comment itself
	var comment = UI_COMMENT.instantiate() # Comment itself
	
	var path = data.comment.path.split(".")
	for _i in range(path.size() - 2):
		comment_box.add_child(UI_THREADLINE.instantiate())
	
	comment.get_node("cont_meta/author").text = DataHelper.get_full_username(data.creator.actor_id)
	comment.get_node("cont_meta/time").text = DataHelper.get_time_since(data.comment.published)
	comment.get_node("cont_body/body").text = data.comment.content
	
	comment_cont.add_child(comment_box)
	comment_box.add_child(comment)
	comments_by_id[str(data.comment.id)] = comment_cont
	comment_cont.set_meta("parent_id", path[-2])
	


func _set_style():
	$post/vbox/cont_title/title.theme = Globals.FONT_THEME_TITLE
	$post/vbox/cont_body/body.theme = Globals.FONT_THEME_BODY
	$post/vbox/cont_meta/row1/post_author.theme = Globals.FONT_THEME_META
	$post/vbox/cont_meta/row1/dot1.theme = Globals.FONT_THEME_META
	$post/vbox/cont_meta/row1/post_community.theme = Globals.FONT_THEME_META
	$post/vbox/cont_meta/row2/dot1.theme = Globals.FONT_THEME_META
	$post/vbox/cont_meta/row2/time.theme = Globals.FONT_THEME_META
	$post/vbox/cont_meta/row2/dot2.theme = Globals.FONT_THEME_META
	$post/vbox/cont_meta/row2/numcomments.theme = Globals.FONT_THEME_META
