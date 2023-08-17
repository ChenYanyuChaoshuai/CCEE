extends ItemList


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func get_class_score(student):
	self.clear()
	var class_score = student.get_class_score()
	var space = ":    "
	for line in class_score:
		var s = "   " + line[0] + space +str(line[1])
		self.add_item(s)
