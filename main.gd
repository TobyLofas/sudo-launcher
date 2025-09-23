extends Control

@onready var library = %Library
@onready var settings = %Settings

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settings.build_library.connect(build_library)
	DisplayServer.window_set_min_size(Vector2i(960,540))

func build_library(directories : Array[String]) -> void:
	library.build(directories)
