class_name Ability
extends Node

var abilities = {
	"logic": 1, 
	"language": 1, 
	"cognition": 1, 
	"emotion": 1
}


func _init():
	pass


func get_ability(key: String) -> int:
	return abilities[ability_map(key)]

func set_ability(key: String, _value: int):
	abilities[ability_map(key)] = _value

func ability_map(key: String):
	if key == "认知":
		return "cognition"
	elif key == "逻辑":
		return "logic"
	elif key == "语言":
		return "language"
	elif key == "情感":
		return "emotion"
	else:
		return key

	

