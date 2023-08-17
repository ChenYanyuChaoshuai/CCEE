extends Button

var God = load("res://0807/myclass/parents_class/God.gd")
var god


# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the "pressed" signal to the "_on_Button_pressed" function.
	god =  God.new()
	god.test()
	connect("pressed", self, "_on_Button_pressed")

# This function will be called when the button is pressed.
func _on_Button_pressed():
#	print("0807 i am test 0807")
#	god = God.new()
#	print("call god")
#	god.test()
	pass
