class_name Game extends Resource

@export var name: String
@export var path: String
@export var icon: String
@export var year: int
@export var developer: String
@export var tags: Array[String]

func _init(p_name = "default", p_path = Global.base_dir, p_icon = Global.default_icon_path, p_year = 0000, p_dev = ""):
	name = p_name
	path = p_path
	icon = p_icon
	year = p_year
	developer = p_dev
