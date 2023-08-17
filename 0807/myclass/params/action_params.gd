class_name Action_params
var _name
var _pre = {}
var _co = 0
var _value
var _time 
var _available_count
var _total_count

func get_name():
	return _name

func set_name(name):
	_name = name

func get_pre():
	return _pre

func set_pre(pre: String):
	_pre = parse_json(pre)

func get_value():
	return _value

func set_value(value):
	_value = parse_json(value)

func get_time():
	return _time

func set_time(time):
	_time = time

func get_available_count():
	return _available_count

func set_available_count(available_count):
	_available_count = available_count

func get_total_count():
	return _total_count

func set_total_count(total_count):
	_total_count = total_count

func get_co():
	return _co

func set_co(value):
	_co = float(value)
