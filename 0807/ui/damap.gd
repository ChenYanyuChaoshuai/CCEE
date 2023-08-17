extends Panel


var button_mapping = {
	"classroom": "firstLove",
	"office": "classTeacher",
	"dormitory": "self",
	"bookstore": "boss",
	"cybercafe": "bestFriend",
	"hospital": "mother"
}



func _ready():
	for button in button_mapping.keys():
		get_node("locs_panel/" + button).connect("pressed", self, "_on_button_pressed", [button])

func _on_button_pressed(button_name):
	# 首先，将所有的按钮都设置为不可见
	for button in button_mapping.values():
		get_node("person_panel/" + button).visible = false
	# 然后，将对应的按钮设置为可见
	var corresponding_button = button_mapping[button_name]
	get_node("person_panel/" + corresponding_button).visible = true
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
