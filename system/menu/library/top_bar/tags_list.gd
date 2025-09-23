extends MenuButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_popup().id_pressed.connect(tag_untag)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func tag_untag(id : int) -> void:
	if get_popup().is_item_checked(id):
		get_popup().set_item_checked(id, false)
	else: 
		get_popup().set_item_checked(id, true)
