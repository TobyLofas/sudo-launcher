extends Control

@onready var library = %Library
@onready var directory_manager = %DirectoryManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	directory_manager.build_library.connect(build_library)
	DisplayServer.window_set_min_size(Vector2i(960,540))
	build_library()

func build_library() -> void:
	library.load_tags()
	library.load_from_register()
	library.refresh_game_list()
	library._on_game_list_item_selected(0)
