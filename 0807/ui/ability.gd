extends Panel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta): 
	pass

func get_ability(student):
	var logic = $logic
	var language = $language
	var cognition = $cognition
	var emotion = $emotion
	logic.text = "逻辑：" + str(student.get_ability("logic"))
	language.text = "语言：" + str(student.get_ability("language"))
	cognition.text = "认知：" + str(student.get_ability("cognition"))
	emotion.text = "情感：" + str(student.get_ability("emotion"))
