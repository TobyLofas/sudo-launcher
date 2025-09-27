extends Node

var base_dir : String = "res://" if OS.has_feature("editor") else OS.get_executable_path().get_base_dir() + "\\"
var games_dir : String = "games/" if OS.has_feature("editor") else "games\\"
var data_dir : String = "data/" if OS.has_feature("editor") else "data\\"
var library_dir : String = data_dir + "library/" if OS.has_feature("editor") else "library\\"
var default_icon_path : String = "res://system/texture/icon.svg"
