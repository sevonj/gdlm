extends Node
"""
	ui.gd
	
	This manages main UI things, such as which view is visible
	
"""

var page_view: Control
var feed_view: Control

func _open_page(base_url: String, id: int):
	page_view.show()
	page_view._load_page(base_url, id)
	feed_view.hide()

func _close_page():
	page_view.hide()
	feed_view.show()

