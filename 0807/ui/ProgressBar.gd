extends ProgressBar


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.min_value = 6
	self.max_value = 22


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#func _process(delta):
#	# 这里你可以根据你的需要设置进度条的值
#	self.value = 10
