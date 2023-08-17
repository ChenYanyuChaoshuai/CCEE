#class_name Student
extends Node

var _name = '杨悟'
var score : Score
var ability : Ability
var san = 100

var Score = load("res://0807/myclass/parents_class/Score.gd")
var Ability = load("res://0807/myclass/parents_class/Ability.gd")
var Action = load("res://0807/myclass/parents_class/Action.gd")
var Task = load("res://0807/myclass/parents_class/Task.gd")

func _init():
	print("STUDENT:init start")
	score = Score.new()  # 创建 Score 类的实例
	ability = Ability.new() # 创建 Ability 类的实例


# 获取学科类分数
func get_class_score():
	return score.get_class_score()

# 获取亲密度类分数
func get_rel_score():
	return score.get_rel_score()

# 修改分数（亲密值）
func modify_score(key, new_score):
	score.set_score(key, new_score)

# 按key获取分数值（亲密值）
func get_score(key):
	return score.get_score(key)

# 修改能力
func modify_ability(key, new_ability):
	ability.set_ability(key, new_ability)

# 获取能力值
func get_ability(key):
	return ability.get_ability(key)

 
# 添加san的get和set方法
func set_san(new_san):
	if new_san > 100:
		san = 100
	elif new_san < 0:
		san = 0
	else:
		san = new_san

func get_san():
	return san

# 增加或减少分数
func increase_or_down_score_from_value(_value, gain_list):
	print(_value)
	for key in _value.keys():
		# key是分数名称，val是值
		var val = _value[key]
		var new_val = get_score(key) + val
		modify_score(key, new_val)
		gain_list.append(key + ":" + str(val))
	return gain_list


func increase_or_down_ability_from_value(_value):
	# print(_value)
	for key in _value.keys():
		# key是分数名称，val是值
		var val = _value[key]
		var new_val = get_ability(key) + val
		modify_ability(key, new_val)



# 学生执行一个行动的方法
func act_action(action):
	# 1.需要先验证前置需求是否满足
	var pre = action.get_pre()
	for key in pre.keys():
		print("pre: " + key + "---" + str(pre[key]))
		# print("ability: " + str(ability.get_ability(key)))
		if ability.get_ability(key) >= int(pre[key]):
			continue
		else:
			myGlobal.call_dia("系统: 能力不足")
			return [false, ""]
	
	var gain_list = []
	
	# 2.当一个行动被执行的时候，会改变学生的分数
	# 获得分数的增益
	var value = action.get_value()
	gain_list = increase_or_down_score_from_value(value, gain_list)

	# 3.当一个行动有能力系数的时候，计算能力增益
	var ability_co = action.get_co()
	print(action.get_name() + "co:" + str(ability_co))
	if ability_co and ability_co > 0:
		ability_co = process_number(ability_co)
		# 如果处理完不是0，才有结算的必要
		if ability_co and ability_co > 0: 
			# 正式结算能力
			# 能力 = 旧能力 + 处理过的co
			var pre_ability = action.get_pre()
			for ability_key in pre_ability.keys():
				modify_ability(ability_key, get_ability(ability_key) + ability_co )
				gain_list.append(ability_key + ":" + str(ability_co))
	return [true, gain_list]


# 处理策划的需求的数字
func process_number(number):
	var integer_part = int(number)
	var decimal_part = number - integer_part
	var random_number = randf()
	if random_number < decimal_part:
		return integer_part + 1
	else:
		return integer_part

	
# 学生任务结算
# 返回一个增益，让上层去调对话
func done_task(task: Task):
	print("done_task")
	print(task._to_string())
	# 获得收益
	var value = task.get_benefit()
	increase_or_down_ability_from_value(value)

	return value
	

	# 获取惩罚
	# var penalty = task.get_penalty()
	# set_san(int(get_san()) - int(penalty))

