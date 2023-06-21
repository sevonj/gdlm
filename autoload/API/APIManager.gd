extends Node

#var base_url = "https://suppo.fi"

const REQ_HEADER = ["Accept: application/json"]

@onready var httprequest = HTTPRequest.new()

func _ready():
	add_child(httprequest)


# Common API request func
func api_request(url: String, method = HTTPClient.METHOD_GET) -> Dictionary:
	print("requesting:",url)
	httprequest.request(url, REQ_HEADER)
	var result = await httprequest.request_completed
	
	if len(result) > 3:
		if result[1] == 200:
			var json = JSON.new()
			json.parse(result[3].get_string_from_utf8())
			return json.get_data()
	
	print("api_request failed.")
	return {}


#---------------#
# Request types #
#---------------#

func GetComments(base_url, params: Dictionary) -> Dictionary:
	var url = base_url + "/api/v3/comment/list" + params_to_string(params)
	return await api_request(url)

func GetPost(base_url, params: Dictionary) -> Dictionary:
	var url = base_url + "/api/v3/post" + params_to_string(params)
	return await api_request(url)

#https://join-lemmy.org/api/interfaces/GetPosts.html
#func GetPosts(params: Dictionary) -> Dictionary:
#	var url = base_url + "/api/v3/post/list"
	
	#url += "?id=" + str(post_id)
	#return await api_request(url)

func parse_json_response(result, response_code, headers, body):
	if response_code == 200:
		var json = JSON.new()
		json.parse(body.get_string_from_utf8())
		return json.get_data()
	else:
		print("Request failed with response code: ", response_code)
		return null

func params_to_string(params: Dictionary) -> String:
	var url = "?"
	for key in params:
		url += key + "=" + str(params[key]) + "&"
	return url
