extends Node2D

var dormitory
var classroom
var bookstore
var hospital
var office
var wb

var bg_list


# Called when the node enters the scene tree for the first time.
func _ready():
	dormitory = get_node("Dormitory")
	classroom = get_node("Classroom-background")
	bookstore = get_node("Bookstore")
	hospital = get_node("Hospital")
	office = get_node("Office")
	wb = get_node("Wb")

	bg_list = [dormitory, classroom, bookstore, hospital, office, wb]

	activate_bg(classroom)

func activate_bg(bg):
	for item in bg_list:
		# print(item == bg)
		if item == bg:
			item.visible = 1
		else:
			item.visible = 0

# --------------------------------------------
func _on_button_activate_dormitory():
	activate_bg(dormitory)
func _on_button_activate_classroom():
	activate_bg(classroom)
func _on_button_activate_bookstore():
	activate_bg(bookstore)
func _on_button_activate_hospital():
	activate_bg(hospital)
func _on_button_activate_office():
	activate_bg(office)
func _on_button_activate_wb():
	activate_bg(wb)
	




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
