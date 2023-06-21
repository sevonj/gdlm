extends Node

const UI_DEFAULT_IMG_PATH = "res://ui/res/default_image.png"
const UI_DEFAULT_IMG = preload("res://ui/res/default_image.png")
const UI_STYLEBOX_POSTCARD = preload("res://ui/res/stylebox_postcard.tres")

const FONT_THEME_BODY = preload("res://ui/res/font_theme_body.tres")
const FONT_THEME_META = preload("res://ui/res/font_theme_meta.tres")
const FONT_THEME_TITLE = preload("res://ui/res/font_theme_title.tres")
const FONT_THEME_POSTCARD_TITLE = preload("res://ui/res/font_theme_postcard_title.tres")
const FONT_THEME_POSTCARD_META = preload("res://ui/res/font_theme_postcard_meta.tres")

var current_community: String = "https://suppo.fi/c/photogrammetry"

func _set_current_community(url: String):
	print("_set_current_community: ", url)
	current_community = url
