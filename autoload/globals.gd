extends Node

const UI_DEFAULT_IMG = preload("res://ui/default_image.png")
const UI_STYLEBOX_POSTCARD = preload("res://ui/stylebox_postcard.tres")

var current_community: String = "https://suppo.fi/c/photogrammetry"

func _set_current_community(url: String):
	print("_set_current_community: ", url)
	current_community = url
