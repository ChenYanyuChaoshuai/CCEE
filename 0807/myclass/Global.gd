extends Node

func call_dia(text: String):
	var resource = DialogueManager.get_resource_from_text("~ dia\n" + text)
	yield(DialogueManager.show_example_dialogue_balloon("dia", resource),"completed")
