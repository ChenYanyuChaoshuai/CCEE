extends Panel
var GOD = load("res://0807/myclass/parents_class/God.gd")

# 学生变量
var student

# 节点：能力表
var ability_node

# 节点：学科分数表
var scorelist

# 节点：表
var tree

# 节点：god
var god

# 目前显示的表
var current_show_table = "action"

# 节点：剩余回合数的标签
var remain_round_label

# 选中的行动名字
var selected_action_name

# 节点：当前时间
var timeline

# 节点：时间轴那一条东西
var timeline_bar

# 是否显示已经完成的
var isdoneornot = true

# 节点：go
var mygo

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# 初始化上帝视角
	god = GOD.new()
	
	# 获取上帝视角中的student
	student = god.get_student()

	# 设置对话系统的全局状态与方法
	# 把god当做游戏状态给他，虽然god里面的东西挺多的
	DialogueManager.game_states = [god, student.ability]

	# 初始化树
	tree = get_node("main_tree_scroll/main_tree")
	tree.select_mode = Tree.SELECT_ROW

	# 让树可以滚动
	var scroll_container = get_node("main_tree_scroll")
	scroll_container.set_h_scroll(50)
	scroll_container.set_v_scroll(100)

	# 获得go的节点
	mygo = get_node("go")

	# 默认读行动表
	show_action()

	# 获取剩余回合节点
	remain_round_label = get_node("remain_rounds")

	# 获取当前时间节点
	timeline = get_node("nowtime")

	# 获取时间轴那一条东西的节点
	timeline_bar = get_node("ProgressBar")
	timeline_bar.min_value = 6
	timeline_bar.max_value = 22

	# 获取能力表
	ability_node = get_node("ability")
	scorelist = get_node("scorelist")




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# 实时刷新剩余回合
	remain_round_label.text = "剩余" + str(god.get_remain_rounds()) + "回合"
	# 实时刷新能力值
	ability_node.get_ability(student)
	# 实时刷新学科分数
	scorelist.get_class_score(student)
	# 实时刷新当前时间
	timeline.text = god.get_timeline()
	# 实时刷新时间轴
	timeline_bar.value = god.get_time_in_hour()

# 显示任务表
func show_task():
	tree.clear()
	var task_list = god.get_task_list_with_flag(isdoneornot)

	# 创建列
	tree.set_columns(6)
	# 设置每一列的最小宽度
	tree.set_column_min_width(0, 100)  # 你可以根据你的需要调整这个数值
	tree.set_column_min_width(1, 60)  # 你可以根据你的需要调整这个数值
	tree.set_column_min_width(2, 70)  # 你可以根据你的需要调整这个数值
	tree.set_column_min_width(3, 150)  # 你可以根据你的需要调整这个数值
	tree.set_column_min_width(4, 150)  # 你可以根据你的需要调整这个数值
	tree.set_column_min_width(5, 150)  # 你可以根据你的需要调整这个数值

	
	# 创建一个根项作为列标题
	var root = tree.create_item()
	root.set_text(0, " 任务名称")
	root.set_text(1, "总回合")
	root.set_text(2, "剩余回合")
	root.set_text(3, "行动目标")
	root.set_text(4, "分数目标")
	root.set_text(5, "收益")
	
	# 添加数据
	for line in task_list:
		var item = tree.create_item(root)
		item.set_text(0, line.get_name())
		item.set_text(1, line.get_total_time_limit())
		item.set_text(2, str(line.get_remaining_time()))
		var s_goal_action = ""
		if not line.get_goal_action().empty():
			# s_goal_action = line.get_goal_action()["action"] + ":" + str(int(line.get_goal_action()["action_times"]))
			var action = line.get_goal_action().get("action", "")
			if action != "":
				var action_times = line.get_goal_action().get("action_times", 0)
				s_goal_action = action + ":" + str(int(action_times))
		item.set_text(3, s_goal_action)
		item.set_text(4, str(line.get_goal_score()).replace("{","").replace("}",""))
		item.set_text(5, str(line.get_benefit()).replace("{","").replace("}",""))
	
# 显示行动表
func show_action():
	tree.clear()
	var action_list = god.get_action_list_with_flag(isdoneornot)

	# 创建列
	tree.set_columns(6)
	# 设置每一列的最小宽度
	tree.set_column_min_width(0, 120)  # 你可以根据你的需要调整这个数值
	tree.set_column_min_width(1, 150)  # 你可以根据你的需要调整这个数值
	tree.set_column_min_width(2, 150)  # 你可以根据你的需要调整这个数值
	tree.set_column_min_width(3, 70)  # 你可以根据你的需要调整这个数值
	tree.set_column_min_width(4, 70)  # 你可以根据你的需要调整这个数值
	tree.set_column_min_width(5, 70)  # 你可以根据你的需要调整这个数值

	
	# 创建一个根项作为列标题
	var root = tree.create_item()
	root.set_text(0, " 行动名称")
	root.set_text(1, "需求")
	root.set_text(2, "收益")
	root.set_text(3, "耗时")
	root.set_text(4, "可用次数")
	root.set_text(5, "总次数")
	
	# 添加数据
	for line in action_list:
		var item = tree.create_item(root)
		item.set_text(0, line.get_name())
		item.set_text(1, str(line.get_pre()).replace("{","").replace("}",""))
		item.set_text(2, str(line.get_value()).replace("{","").replace("}",""))
		item.set_text(3, line.get_time())
		item.set_text(4, str(line.get_available_count()))
		item.set_text(5, str(line.get_total_count()))

# 显示关系表
func show_rel():
	tree.clear()
	# 定义变量并获取分数
	var self_score = student.get_score("Self")
	var class_teacher_score = student.get_score("ClassTeacher")
	var school_score = student.get_score("School")
	var mother_score = student.get_score("Mother")
	var best_friend_score = student.get_score("BestFriend")
	var first_love_score = student.get_score("FirstLove")

	var rel_list = [
		["自我", str(self_score)],
		["班主任", str(class_teacher_score)],
		["学校", str(school_score)],
		["母亲", str(mother_score)],
		["挚友", str(best_friend_score)],
		["初恋", str(first_love_score)]
	]

	# 创建列
	tree.set_columns(2)
	# 设置列的最小宽度
	tree.set_column_min_width(0, 150)  # 你可以根据你的需要调整这个数值
	tree.set_column_min_width(1, 150)  # 你可以根据你的需要调整这个数值

	# 创建一个根项作为列标题
	var root = tree.create_item()
	root.set_text(0, " 角色")
	root.set_text(1, "好感度")

	for line in rel_list:
		var item = tree.create_item(root)
		item.set_text(0, line[0])
		item.set_text(1, line[1])

	# 添加数据
	# for i in range(6):
	# 	var item = tree.create_item(root)
	# 	if i < len(rel_list):
	# 		item.set_text(0, rel_list[i])  # 假设rel_list[i]是一个字符串
	# 	else:
	# 		item.set_text(0, "")  # 如果没有足够的数据，就留空

	# 	if i+1 < len(rel_list):
	# 		item.set_text(1, rel_list[i+1])  # 假设rel_list[i+1]是一个字符串
	# 	else:
	# 		item.set_text(1, "")  # 如果没有足够的数据，就留空
	
# 获取选择的行动的名字
func set_selected_action_name(selected_name: String):
	var selected_action_label = get_node("selected_action_name")
	selected_action_label.text = selected_name

# 刷新表格
func check_tables():
	match current_show_table:
		"action":
			show_action()
			return
		"task":
			show_task()
			return
		"rel":
			show_rel()
			return
	return

# 切换到地图:设置表格和go的可见性为false
func check_map():
	# 设置那个表\行动按钮\筛选按钮的visible
	var main_tree = get_node("main_tree_scroll")
	var go = get_node("go")
	var select_button = get_node("isdoneornot")
	var damap = get_node("damap")
	
	main_tree.visible = false
	go.visible = false
	select_button.visible = false

	damap.visible = true

# 切换到非地图:设置表格和go的可见性为false
func check_out_map():
		# 设置那个表\行动按钮\筛选按钮的visible
	var main_tree = get_node("main_tree_scroll")
	var go = get_node("go")
	var select_button = get_node("isdoneornot")
	var damap = get_node("damap")
	
	main_tree.visible = true
	go.visible = true
	select_button.visible = true

	damap.visible = false

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# 节点触发绑定的方法
# 当节点被选中时，读取到被选中的对象
func _on_tree_item_selected():
	var selected_item = tree.get_selected()
	if selected_item:
		if current_show_table == "action":
			# 设置行动名称
			selected_action_name = selected_item.get_text(0)
			set_selected_action_name(selected_action_name)

		# # 对选中行的所有单元格进行操作
		# for i in range(tree.get_columns()):
		# 	var cell_text = selected_item.get_text(i)
		# 	print("Column ", i, ": ", cell_text)

# 点任务
func _on_button_click_show_task():
	check_out_map()
	show_task()
	current_show_table = "task"

	mygo.visible = false



# 点行动
func _on_button_click_show_action():
	check_out_map()
	show_action()
	current_show_table = "action"

	mygo.visible = true

# 点关系
func _on_button_click_show_rel():
	check_out_map()
	show_rel()
	current_show_table = "rel"

	mygo.visible = false

# 点结束回合
func _on_button_click_finish_round():
	var confirmationDialog = get_node("ConfirmationDialog")
	confirmationDialog.popup_centered()

func _on_button_click_finish_round_really():
	god.finish_round()
	check_tables()

# 点行动
func _on_button_click_go():
	if selected_action_name:
		god.god_do_action(selected_action_name)
	else:
		print("WARNING: 请先选择一个行动")
	show_action()

# 点筛选
func _on_button_click_isdoneornot():
	isdoneornot = not isdoneornot
	print(isdoneornot)
	match current_show_table:
		"task":
			show_task()
		"action":
			show_action()
		"rel":
			show_rel()

# 点地图
func _on_button_show_map():
	check_map()
