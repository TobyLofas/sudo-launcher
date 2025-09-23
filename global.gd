extends Node

var base_dir : String = "res://" if OS.has_feature("editor") else OS.get_executable_path().get_base_dir() + "\\"
var library_dir : String = "library/" if OS.has_feature("editor") else "library\\"
var games_dir : String = "games/" if OS.has_feature("editor") else "games\\"
var default_icon_path : String = base_dir + "system/texture/icon.svg"
