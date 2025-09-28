extends Node

##REQUIRED DIRECTORIES
var base_dir : String = "res://" if OS.has_feature("editor") else OS.get_executable_path().get_base_dir() + "/"
var data_dir : String = "data/"
var library_dir : String = data_dir + "library/"

##OPTIONAL DIRECTORIES
var games_dir : String = "games/"
var icons_dir : String = "icons/"

var default_icon_path : String = "res://system/texture/icon.svg"

##CSV FILENAMES
var directories_file_name : String = "directories.csv"
var tags_file_name : String = "tags.csv"
var blacklist_file_name : String = "blacklist.csv"

#var selected_game : Game
