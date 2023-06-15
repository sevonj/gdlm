extends Node

var feed_view
var page_view
var sidebar

func _open_post(id: String):
	if !is_instance_valid(feed_view):
		push_error("LemmyViewer._open_post(): feed_view is invalid")
	if !is_instance_valid(page_view):
		push_error("LemmyViewer._open_post(): page_view is invalid")
	
	feed_view.hide()
	page_view.show()
	page_view.get_page(id)

func _close_post():
	if !is_instance_valid(feed_view):
		push_error("LemmyViewer._open_post(): feed_view is invalid")
	if !is_instance_valid(page_view):
		push_error("LemmyViewer._open_post(): page_view is invalid")
	
	feed_view.show()
	page_view.hide()
