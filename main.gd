extends Control



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DisplayServer.window_set_min_size(Vector2i(960,540))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
