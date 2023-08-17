class_name Score
extends Node

var scores_dict = {
	"Chinese": 0,
	"Math": 0,
	"English": 0,
	"Physics": 0,
	"Chemistry": 0,
	"Biology": 0,
	"Self": 0,
	"ClassTeacher": 0,
	"School": 0,
	"Mother": 0,
	"BestFriend": 0,
	"FirstLove": 0
}


func _init():
	print("SCORE:INIT")
	pass

func get_score(key):
	return scores_dict[score_map(key)]

func set_score(key, _value):
	scores_dict[score_map(key)] = _value

func score_map(key):
	match key:
		"语文":
			return "Chinese"
		"数学":
			return "Math"
		"英语":
			return "English"
		"物理":
			return "Physics"
		"化学":
			return "Chemistry"
		"生物":
			return "Biology"
		"自我":
			return "Self"
		"班主任":
			return "ClassTeacher"
		"学校":
			return "School"
		"母亲":
			return "Mother"
		"挚友":
			return "BestFriend"
		"初恋":
			return "FirstLove"
		_:
			return key


func get_class_score():
	# 返回一个列表，0位置是学科的中文，1位置是值
	var ret_list = []
	ret_list.append(
		["语文", scores_dict["Chinese"]]
	)
	ret_list.append(
		["数学", scores_dict["Math"]]
	)
	ret_list.append(
		["英语", scores_dict["English"]]
	)
	ret_list.append(
		["物理", scores_dict["Physics"]]
	)
	ret_list.append(
		["化学", scores_dict["Chemistry"]]
	)
	ret_list.append(
		["生物", scores_dict["Biology"]]
	)

	return ret_list

func get_rel_score():
	# 返回一个列表，0位置是关系的中文，1位置是指
	var ret_list = []
	ret_list.append(
		["自我", scores_dict["Self"]]
	)
	ret_list.append(
		["班主任", scores_dict["ClassTeacher"]]
	)
	ret_list.append(
		["学校", scores_dict["School"]]
	)
	ret_list.append(
		["母亲", scores_dict["Mother"]]
	)
	ret_list.append(
		["挚友", scores_dict["BestFriend"]]
	)
	ret_list.append(
		["初恋", scores_dict["FirstLove"]]
	)

	return ret_list




