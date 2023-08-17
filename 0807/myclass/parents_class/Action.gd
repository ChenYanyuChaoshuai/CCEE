class_name Action
extends Node

var _name
var _pre
# coefficient 系数
var _co
var _value
var _time
var _available_count: int
var _total_count: int

func _init(actionParams):
	_name = actionParams.get_name()
	_pre = actionParams.get_pre()
	_value = actionParams.get_value()
	_time = actionParams.get_time()
	_available_count = int(actionParams.get_available_count())
	_total_count = int(actionParams.get_total_count())
	_co = float(actionParams.get_co())


func _to_string():
	return "Action: { name: " + str(_name) + ", pre: " + str(_pre) + ", value: " + str(_value) + ", time: " + str(_time) + ", available_count: " + str(_available_count) + ", total_count: " + str(_total_count) + " }"

 
# Generated get and set methods for variables
func get_name():
	return _name

func set_name(new_name):
	_name = new_name

func get_pre():
	return _pre

func set_pre(new_pre):
	_pre = new_pre

func get_value():
	return _value

func set_value(new_value):
	_value = new_value

func get_time():
	return _time

func set_time(new_time):
	_time = new_time

func get_available_count():
	return _available_count

func set_available_count(new_available_count):
	_available_count = new_available_count

func get_total_count():
	return _total_count

func set_total_count(new_total_count):
	_total_count = new_total_count

func get_co():
	return _co

func set_co(value):
	_co = float(value)


