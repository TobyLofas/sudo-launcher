extends PopupMenu

func _ready() -> void:
	id_pressed.connect(tag_untag)

func tag_untag(id : int) -> void:
	if is_item_checked(id):
		set_item_checked(id, false)
	else: 
		set_item_checked(id, true)
