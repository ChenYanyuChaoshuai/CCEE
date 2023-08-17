extends Panel




func _ready():
	

	var item_list = $scorelist
	
	item_list.rect_min_size = Vector2(200, 300)

	item_list.add_item("ability 1 xxx")
	item_list.add_item("ability2 xxxx")
	item_list.add_item("ability3 xxxx")
