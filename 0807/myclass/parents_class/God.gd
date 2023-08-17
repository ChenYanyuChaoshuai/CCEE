class_name God
extends Node

# 引入类
var Student = load("res://0807/myclass/parents_class/Student.gd")
var Action = load("res://0807/myclass/parents_class/Action.gd")
var Task = load("res://0807/myclass/parents_class/Task.gd")

# 学生对象
var student

# action参数
var ActionParams = load("res://0807/myclass/params/action_params.gd")
var actionParams

# task参数
var TaskParams = load("res://0807/myclass/params/task_params.gd")
var taskParams

# action列表
var action_list = []
var wait_for_invoke_action_list = []
# task列表
var task_list = []
var wait_for_invoke_task_list = []

# 已完成的任务表
var done_task = []

# 过期的任务表
var overdue_task = []


# 时间轴，当前执行的动作，当前执行的任务
var timeline = 6 * 60
var current_action
var current_task = []

# 回合数
var remain_rounds = 50


# 对话资源
var dialogue_resource = load("res://0807/dialogue/ccee_dia.tres")

func _init():
	print("GOD:INIT")

	# 初始化学生对象
	student = Student.new()

	# 初始化动作、任务参数
	actionParams = ActionParams.new()
	taskParams = TaskParams.new()

	# 读取动作、任务表
	read_action_task_txts()

	# 增加一个对action_lish task_list的处理，即触发与否
	var deal_invoke_actions_ret =  deal_invoke_actions(action_list)
	action_list = deal_invoke_actions_ret[0]
	wait_for_invoke_action_list = deal_invoke_actions_ret[1]

	var deal_invoke_tasks_ret =  deal_invoke_tasks(task_list)
	task_list = deal_invoke_tasks_ret[0]
	wait_for_invoke_task_list = deal_invoke_tasks_ret[1]

	# 触发所有的任务（旧版）（可以触发的任务都放在了task_list中了，可以全部触发的）
	invoke_all_task()

	print("SUCECSS:God init success!")

# 读取行动和任务表
func read_action_task_txts():
	# 读取action表
	read_action_from_txt()
	# 读取task表
	read_task_from_txt()

	print("SUCECSS:read_action_task_txts sucecss!")


# 读action表
func read_action_from_txt(file_path="res://0807/myconfig/action.txt"):
	var file = File.new()
	if file.open(file_path, File.READ) == OK:
		var content = file.get_as_text()
		var lines = content.split("\n")
		for line in lines:
			var data = line.split("\t")
			if data.size() == 6:
				actionParams.set_name(data[0])
				actionParams.set_time(data[1])
				actionParams.set_total_count(data[2])
				actionParams.set_pre(data[4])
				actionParams.set_value(data[5])
				# 初始的可用次数 = 总次数
				actionParams.set_available_count(data[2])

				# 增加能力系数
				actionParams.set_co(data[3])

				action_list.append(Action.new(actionParams))
		file.close()
	else:
		print("Failed to open file")

# 读task表
func read_task_from_txt(file_path="res://0807/myconfig/task.txt"):
	var file = File.new()
	if file.open(file_path, File.READ) == OK:
		var content = file.get_as_text()
		var lines = content.split("\n")
		for line in lines:
			var data = line.split("\t")
			if data.size() == 6:
				taskParams.set_name(data[0])
				taskParams.set_total_time_limit(data[1])
				taskParams.set_remaining_time(data[1])

				taskParams.set_penalty(data[2])
				taskParams.set_goal_action(data[3])
				taskParams.set_benefit(data[4])
				taskParams.set_goal_score(data[5])

				task_list.append(Task.new(taskParams))
		file.close()
	else:
		print("Failed to open file")
	# print(task_list[1])

# 将分钟转换为24小时制的时间格式
func time_to_string(time_in_minutes):
	var hours = time_in_minutes / 60
	var minutes = time_in_minutes % 60
	return "%02d:%02d" % [hours, minutes]

# 增加时间
func add_time(minutes):
	timeline = (timeline + minutes) % (24 * 60) # 保证时间在0到1439之间
	if timeline < 6 * 60: # 如果时间小于6:00
		timeline = 6 * 60 # 将时间设为6:00
	elif timeline > 22 * 60: # 如果时间大于22:00
		timeline = 22 * 60 # 将时间设为22:00
	# print(time_to_string(timeline)) # 打印当前时间
		

# god的执行动作事件
func god_do_action(act_name:String):
	# 获取实际的行动，从action_list中可以读取
	var action = find_action_from_list(act_name)
	# 检查	
	if action.get_available_count() < 1:
		myGlobal.call_dia("系统: 该行动的可用次数不足")
		return
	if timeline + int(action.get_time()) > 60 * 22:
		myGlobal.call_dia("系统: 今天的剩余时间不够执行本次行动")
		return
	# 学生执行动作
	var canDoActionOrNot = student.act_action(action)
	if not canDoActionOrNot[0]:
		return
	# 获取增益信息
	var gain_list = canDoActionOrNot[1]
	# 时间流逝
	add_time(int(action.get_time()))
	# 动作本身的信息改变
	action.set_available_count(action.get_available_count()-1)
	# 弹出动作增益
	var s_gain_print = "系统: 你执行了行动：" + act_name + "   你获得收益：" + str(gain_list)
	# 更新任务
	update_task()
	myGlobal.call_dia(s_gain_print)
	DialogueManager.show_example_dialogue_balloon(action.get_name(), dialogue_resource)
	# 激活下一个动作
	if action.get_available_count() - 1 < 0:
		invoke_next_action(act_name)


# 触发所有的任务,是指把task_list中的任务都激活
func invoke_all_task():
	for task in task_list:
		current_task.append(task)

# 任务被触发，这里的find_task_from_task_list，是去task_list中找，waitfor的实际找不到
func invoke_task(task_name: String):
	var task = find_task_from_task_list(task_name)
	current_task.append(task)

# 任务结束
func finish_task(task):
	# var index = current_task.find(task)
	done_task.append(task)

	# 结算task
	var value = student.done_task(task)

	# 弹出动作增益
	var s_gain_print = "系统: 你完成了任务：" + task.get_name() + "   你获得收益：" + str(value)
	myGlobal.call_dia(s_gain_print)

	# 进入任务对话
	DialogueManager.show_example_dialogue_balloon(task.get_name(), dialogue_resource)



# 更新任务
func update_task():
	# 我需要有一个当前执行的任务列表
	for task in current_task:
		var canOrNot = check_task_can_finish(task)
		# print("task_name:" + task.get_name() + ":" + str(canOrNot))
		if canOrNot:
			finish_task(task)
	# 统一删除，不然会有并发问题
	for task in done_task:
		var index = current_task.find(task)
		if index != -1: 
			current_task.remove(index)
		


# 检查是否可以结束任务
func check_task_can_finish(task: Task):
	var can_finish = true
	# 检查task的两个目标
	var goal_score = task.get_goal_score()
	var goal_action = task.get_goal_action()

	for score_key in goal_score.keys():
		# 阈值
		var limit = goal_score[score_key]
		var now_score = student.get_score(score_key)
		if limit > now_score:
			can_finish = false

	# 如果goal_action是空的，就没有前置要求
	if not goal_action.empty():
		# print(goal_action)
		if goal_action.get("action", "") != "":
			# 有可能找不到，因为数据问题
			# 这里考虑，如果任务没有被激活，那就直接设置为false
			if find_action_from_waitforinvoke_list(goal_action["action"]):
				can_finish = false
			else:
				var limit_action = find_action_from_list(goal_action["action"])
				if limit_action:
					var total_times = limit_action.get_total_count()
					var avaliable_times = limit_action.get_available_count()
					if total_times - avaliable_times < goal_action["action_times"]:
						can_finish = false
	
	return can_finish


# 传入action的名字，找到对应的action
# 是从action_list去找的
# action_list是 激活状态下的action
func find_action_from_list(name: String):
	for action in action_list:
		if action.get_name() == name:
			return action
	return null

# 在未激活的里面找
func find_action_from_waitforinvoke_list(name: String):
	for action in wait_for_invoke_action_list:
		if action.get_name() == name:
			return action
	return null

# 传入action的名字，找到对应的action
func find_task_from_task_list(name: String):
	for task in task_list:
		if task.name == name:
			return task
	return null

# 从待激活中去找
func find_task_from_waitforinvoke_list(name: String):
	for task in wait_for_invoke_task_list:
		if task.get_name() == name:
			return task
	return null

# 获取时间的方法
func get_timeline():
	return time_to_string(timeline)

# 获取小时的时间
func get_time_in_hour():
	return timeline / 60
	
# 结束回合
func finish_round():
	if remain_rounds < 1:
		finish_game()
	# 回合数减1
	remain_rounds = remain_rounds - 1
	# 更新时间和时间轴(时间轴会动态更新)
	timeline = 6 * 60
	# 更新未任务列表
	update_unfinish_tasks(current_task)

func update_unfinish_tasks(tasks):
	var will_del_tasks = []
	for task in tasks:
		var remain = int(task.get_remaining_time())
		# 回合结束，-1 剩余回合数
		remain = remain - 1
		if remain < 1:
			# 一会统一删除
			will_del_tasks.append(task)
		else:
			task.set_remaining_time(remain)

	# 执行真正的删除
	for task in will_del_tasks:
		var index = current_task.find(task)
		if index != -1:
			current_task.remove(index)



# 获取任务列表 
func get_task_list():
	return task_list

func get_task_list_with_flag(flag):
	if flag:
		return current_task
	else:
		return done_task


# 获取动作列表
func get_action_list():
	return action_list
# 获取剩余回合
func get_remain_rounds():
	return remain_rounds

# 获得student
func get_student():
	return student

# 筛选是否已经完成的任务
func get_action_list_with_flag(flag):
	var ret_list = []
	# 如果是true，就筛选未完成的
	if flag:
		for action in action_list:
			if int(action.get_available_count()) < 1:
				continue
			else:
				ret_list.append(action)
	else:
		for action in action_list:
			if int(action.get_available_count()) < 1:
				ret_list.append(action)
			else:
				continue
	
	return ret_list

# action包装器，给action增加一个是否激活的状态
# action 的壳
# func action_add_ke(action):

# 开局处理action，结尾为1的直接激活，其他的待激活
func deal_invoke_actions(al):
	var ret_list = []
	var wait_for_invoke_al = []
	# 初始状态，只有后缀为1的是被激活的
	for action in al:
		if action.get_name().ends_with("1"):
			ret_list.append(action)
		else:
			wait_for_invoke_al.append(action)
	
	return [ret_list, wait_for_invoke_al]

# 开局处理task，结尾为1的直接激活，其他的待激活
func deal_invoke_tasks(tl):
	var ret_list = []
	var wait_for_invoke_tl = []
	# 初始状态，只有后缀为1的是被激活的
	for task in tl:
		if task.get_name().begins_with("学校"):
			ret_list.append(task)
		else:
			wait_for_invoke_tl.append(task)
	
	return [ret_list, wait_for_invoke_tl]

# 将等待激活的任务激活
func invoke_wai_for_task(task:Task):
	if task:
		current_task.append(task)
		var index = wait_for_invoke_task_list.find(task)
		if index != -1:
			wait_for_invoke_task_list.remove(index)
		else:
			print("ERROR: invoke_wai_for_task wait_for_invoke_task_list.find找不到")
	else:
		print("ERROR invoke_wai_for_task task为空")

func invoke_wai_for_aciton(action):
	if action:
		action_list.append(action)
		var index = wait_for_invoke_action_list.find(action)
		if index != -1:
			wait_for_invoke_action_list.remove(index)
		else:
			print("ERROR: invoke_wai_for_aciton wait_for_invoke_action_list.find找不到")
	else:
		print("ERROR invoke_wai_for_aciton action为空")


# 检查任务是否被激活
# TODO:这里可能有问题，这是去task_list中找的。但是任务会去到cur里面，完成了还会被删除。
# 可以考虑从waitfor里找，找不到就是已经激活过了
func check_task_complete(task_name: String):
	# 先从task_list中去找
	var task = find_task_from_waitforinvoke_list(task_name)

	# 还没有被激活
	if not task:
		return true
	else:
		return false

# 设置任务为被激活状态
func set_task_available(task_name: String):
	for task in wait_for_invoke_task_list:
		if task.get_name() == task_name:
			invoke_wai_for_task(task)
			return
		else:
			continue
	print("ERROR: 没有找到这个任务 set_task_available")

# 设置行动为被激活状态
func set_action_available(action_name: String):
	for action in wait_for_invoke_action_list:
		if action.get_name() == action_name:
			invoke_wai_for_aciton(action)
			return
		else:
			continue
	print("ERROR: 没有找到这个aciton set_action_available")

# 激活下一个action
func invoke_next_action(action_name: String):
	var next_action_name = get_next_action_name(action_name)
	if next_action_name:
		var action = find_action_from_waitforinvoke_list(next_action_name)
		if action:
			# 加入已激活
			action_list.append(action)
			var index = wait_for_invoke_action_list.find(action)
			# 从未激活删掉
			if index != -1:
				wait_for_invoke_action_list.remove(index)


# 输入学校1 获得学校2
func get_next_action_name(an: String):
	var last_char = an[an.length() - 1]
	var next_action_name = ""

	var digits = "0123456789"

	if last_char in digits:
		var next_number = int(last_char) + 1
		next_action_name = an.substr(0, an.length() - 1) + str(next_number)
		return next_action_name
	else:
		print("Action name doesn't end with a number.")
		return null


func finish_game():
	var final_score = 0
	# 返回一个list，0是学科名，1是学科分数
	var final_score_list = student.get_class_score()
	for items in final_score_list:
		final_score = final_score + items[1]

	var final_score_div_10 = final_score / 10
	var final_school = ""

	if final_score_div_10 >= 600:
		final_school = "top2"
	elif final_score_div_10 >= 550:
		final_school = "c9"
	elif final_score_div_10 >= 520:
		final_school = "top10"
	elif final_score_div_10 >= 490:
		final_school = "985"
	elif final_score_div_10 >= 460:
		final_school = "211"
	elif final_score_div_10 >= 430:
		final_school = "一本"
	elif final_score_div_10 >= 410:
		final_school = "二本"
	elif final_score_div_10 >= 350:
		final_school = "专科"
	else:
		final_school = "社会大学"
	
	var s_print = "系统: 你的高考成绩是" + final_score_div_10 +", 考上了" + final_school
	
	myGlobal.call_dia(s_print)

