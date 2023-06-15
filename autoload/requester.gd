extends Node

const REQ_HEADER = ["Accept: application/json"]
const DEFAULT_COMMUNITY = "https://suppo.fi/c/photogrammetry"

@onready var request_group = HTTPRequest.new()
@onready var request_outbox = HTTPRequest.new()
@onready var request_page = HTTPRequest.new()

signal received_outbox(response)
signal received_page(response)

func _ready():
	add_child(request_group)
	add_child(request_outbox)
	add_child(request_page)
	request_group.request_completed.connect(self._request_group_completed)
	request_outbox.request_completed.connect(self._request_outbox_completed)
	request_page.request_completed.connect(self._request_page_completed)

# External: Call these

func _get_group(id: String):
	if request_group.request(id, REQ_HEADER) != OK:
		push_error("Requesting group failed.")

func _get_outbox(id: String):
	if request_outbox.request(id, REQ_HEADER) != OK:
		push_error("Requesting outbox failed.")

func _get_page(id: String):
	if request_page.request(id, REQ_HEADER) != OK:
		push_error("Requesting page failed.")

func _cancel_outbox():
	request_outbox.cancel_request()

func _cancel_page():
	request_page.cancel_request()

func _cancel_all():
	_cancel_outbox()
	_cancel_page()

# Internal use
func _request_group_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	match response.type:
		"Group":
			print(response)
			_get_outbox(response.outbox)
		_:
			push_error("_request_group received invalid type: ", response.type)

func _request_outbox_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	match response.type:
		"OrderedCollection":
			emit_signal("received_outbox", response)
		_:
			push_error("_request_outbox received invalid type: ", response.type)

func _request_page_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	match response.type:
		"Page":
			emit_signal("received_page", response)
		_:
			push_error("_request_page received invalid type: ", response.type)
			
