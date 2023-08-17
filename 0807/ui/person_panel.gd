extends Panel


var dialogue_resource = load("res://0807/dialogue/ccee_dia.tres")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_classTeacher_button_up():
	DialogueManager.show_example_dialogue_balloon("班主任", dialogue_resource) 


func _on_self_button_up():
	DialogueManager.show_example_dialogue_balloon("自我", dialogue_resource) 


func _on_mother_button_up():
	DialogueManager.show_example_dialogue_balloon("母亲", dialogue_resource)


func _on_bestFriend_button_up():
	DialogueManager.show_example_dialogue_balloon("挚友", dialogue_resource)


func _on_firstLove_button_up():
	DialogueManager.show_example_dialogue_balloon("初恋", dialogue_resource)


func _on_boss_button_up():
	DialogueManager.show_example_dialogue_balloon("书店老板", dialogue_resource)
