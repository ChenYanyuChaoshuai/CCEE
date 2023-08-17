extends ConfirmationDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = Color(0, 0.28, 0.67, 1)  # 设置为红色
	self.add_stylebox_override("panel", style_box)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
