extends Node

static func buildURL(base_url: String, params: Dictionary) -> String:
	var url = base_url + "/api/v3/comment/list"
	
	if "auth" in params:
		url += "?auth=" + str(params["auth"])
	if "community_id" in params:
		url += "?community_id=" + str(params["community_id"])
	if "community_name" in params:
		url += "?community_name=" + str(params["community_name"])
	if "limit" in params:
		url += "?limit=" + str(params["limit"])
	if "max_depth" in params:
		url += "?max_depth=" + str(params["max_depth"])
	if "page" in params:
		url += "?page=" + str(params["page"])
	if "parent_id" in params:
		url += "?parent_id=" + str(params["parent_id"])
	if "post_id" in params:
		url += "?post_id=" + str(params["post_id"])
	if "saved_only" in params:
		if params["saved_only"]:
			url += "?saved_only=" + "true"
		else:
			url += "?saved_only=" + "false"
	if "sort" in params:
		url += "?sort=" + str(params["sort"])
	if "type_" in params:
		url += "?type_=" + str(params["type_"])
	return url
