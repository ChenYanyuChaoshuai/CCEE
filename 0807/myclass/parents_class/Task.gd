class_name Task
extends Node

var _name = ""
var _goal_action = {}
var _goal_score = {}
var _benefit = ""
var _penalty = ""
var _remaining_time = 0
var _total_time_limit = 0

func _init(taskParams):
	# print("TASK INIT")
	_name = taskParams.get_name()
	_goal_action = taskParams.get_goal_action()
	_goal_score = taskParams.get_goal_score()
	_benefit = taskParams.get_benefit()
	_penalty = taskParams.get_penalty()
	_remaining_time = taskParams.get_remaining_time()
	_total_time_limit = taskParams.get_total_time_limit()


func _to_string():
	return "Task: { name: " + str(_name) + ", goal_action: " + str(_goal_action) + ", goal_score: " + str(_goal_score) + ", benefit: " + str(_benefit) +  ", penalty: " + str(_penalty) + ", remaining_time: " + str(_remaining_time) + ", total_time_limit: " + str(_total_time_limit)  + " }"
	
 
func get_name():
	return _name

func set_name(new_name):
	_name = new_name

func get_goal_action():
	return _goal_action

func set_goal_action(value: String):
	_goal_action = parse_json(value)

func get_goal_score():
	return _goal_score

func set_goal_score(value: String):
	_goal_score = parse_json(value)

func get_benefit():
	return _benefit

func set_benefit(new_benefit):
	_benefit = new_benefit

func get_penalty():
	return _penalty

func set_penalty(new_penalty):
	_penalty = new_penalty

func get_remaining_time():
	return _remaining_time

func set_remaining_time(new_remaining_time):
	_remaining_time = new_remaining_time

func get_total_time_limit():
	return _total_time_limit

func set_total_time_limit(new_total_time_limit):
	_total_time_limit = new_total_time_limit



