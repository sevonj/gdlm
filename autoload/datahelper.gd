extends Node
"""
	DataHelper
	
	This file provides common help functions
	
"""
func get_id_from_url(url: String) -> int:
	url = url.split("?")[0].split("/")[-1]
	return int(url)

func get_base_url(url: String) -> String:
	return "https://" + url.split("//")[1].split("/")[0]

func get_community_name(actor_id: String) -> String:
	print(actor_id)
	var split = actor_id.split("//")[1].split("/c/")
	return split[1] + "@" + split[0]

func get_full_username(actor_id: String) -> String:
	var split = actor_id.split("//")[1].split("/u/")
	return "@" + split[1] + "@" + split[0]

func get_time_since(timestamp: String) -> String:
	var difference = Time.get_unix_time_from_system() - Time.get_unix_time_from_datetime_string(timestamp)
	if difference < 0:
		return "Posted from the future"
	# seconds
	if difference < 60:
		return str(int(difference)) + "s"
	# minutes
	difference /= 60.0
	if difference < 60:
		return str(int(difference)) + "min"
	# hours
	difference /= 60.0
	if difference < 60:
		return str(int(difference)) + "h"
	# days
	difference /= 24.0
	if difference < 30:
		return str(int(difference)) + "d"
	return "long time ago"
	
func get_image(url: String) -> ImageTexture:
	print("imgurl:",url)
	var httprequest = HTTPRequest.new()
	add_child(httprequest)
	httprequest.request(url)
	var result = await httprequest.request_completed
	httprequest.queue_free()
	
	# Try various image formats
	var image = Image.new()
	if image.load_png_from_buffer(result[3]) == OK:
		return ImageTexture.create_from_image(image)
	if image.load_jpg_from_buffer(result[3]) == OK:
		return ImageTexture.create_from_image(image)
	if image.load_webp_from_buffer(result[3]) == OK:
		return ImageTexture.create_from_image(image)
	
	# Fallback
	print("Failed opening image")
	image.load_from_file(Globals.UI_DEFAULT_IMG_PATH)
	return ImageTexture.create_from_image(image)
