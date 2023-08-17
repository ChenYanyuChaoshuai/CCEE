class_name TaskParams

var _name = ""
var _goal_action = {}
var _goal_score = {}
var _benefit = ""
var _penalty = ""
var _remaining_time = 0
var _total_time_limit = 0

func set_name(value):
	_name = value

func get_name():
	return _name

func get_goal_action():
	return _goal_action

func set_goal_action(value: String):
	_goal_action = parse_json(value)

func get_goal_score():
	return _goal_score

func set_goal_score(value: String):
	_goal_score = parse_json(value)

func set_benefit(value):
	_benefit = parse_json(value)

func get_benefit():
	return _benefit

func set_penalty(value):
	_penalty = value

func get_penalty():
	return _penalty

func set_remaining_time(value):
	_remaining_time = value

func get_remaining_time():
	return _remaining_time

func set_total_time_limit(value):
	_total_time_limit = value

func get_total_time_limit():
	return _total_time_limit
	


