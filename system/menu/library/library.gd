extends Control

@onready var game_list = %GameList
@onready var detail_panel = %DetailPanel
@onready var top_bar = %TopBar

var library : Array[Game] = []
var filtered_library : Array[Game] = []
var selected : Game

var search_filtered : Array[Game]
var tag_filtered : Array[Game]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	top_bar.search_bar.text_changed.connect(search_library)
	top_bar.tags_changed.connect(filter_by_tag)
	top_bar.image_toggle.toggled.connect(toggle_images)
	read_directory("C:\\Users\\tobyl\\Desktop\\Games")
	create_game_list_from_library()
	#save_library()
	load_test()
	_on_game_list_item_selected(0)
	load_library_from_register()

func read_directory(directory : String) -> void:
	var dir = DirAccess.open(directory)
	var t_dir = directory + "\\"
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				#print("Found file: " + file_name)
				var extension : String = file_name.get_slice(".",1)
				var title : String = file_name.get_slice(".",0)
				if extension == "exe" or extension == "lnk":
					var tgame = Game.new(title, t_dir + file_name)
					library.append(tgame)
					var library_path = Global.base_dir + Global.library_dir + title
					if FileAccess.get_sha256(library_path) != "":
						ResourceSaver.save(tgame, library_path + ".tres")
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func create_game_list_from_library() -> void:
	game_list.clear()
	for item in library:
		game_list.add_item(item.name, load(item.icon))


func _on_game_list_item_selected(index: int) -> void:
	selected = library[index]
	detail_panel._refresh_from_data(selected)

func save_library() -> void:
	var register = Register.new()
	register.register = library
	ResourceSaver.save(register, "res://system/register/register.tres")
	

func load_test() -> void:
		var t : Register = load("res://system/register/register.tres") as Register
		library = t.register

func search_library(term : String) -> void:
	if term == "":
		create_game_list_from_library()
	else:
		game_list.clear()
		for item in library:
			if item.name.containsn(term):
				game_list.add_item(item.name, load(item.icon))
				search_filtered.append(item)

func filter_by_tag(tags : Array[String]) -> void:
	print(tags)
	if tags.is_empty():
		create_game_list_from_library()
	else:
		game_list.clear()
		var library_filtered: Array[Game]  
		for item in library:
			for tag in tags:
				if tag in item.tags:
					game_list.add_item(item.name, load(item.icon))
					tag_filtered.append(item)

func apply_filters() -> void:
	game_list.clear()
	for item in tag_filtered:
		for s_item in search_filtered:
			if item == s_item:
				filtered_library.append(item)
	create_game_list_from_filtered_library()

func apply_ordering() -> void:
	pass

func create_game_list_from_filtered_library() -> void:
	game_list.clear()
	for item in filtered_library:
		game_list.add_item(item.name, load(item.icon))

func toggle_images(state: bool) -> void:
	for index in game_list.item_count:
		if state:
			game_list.set_item_icon(index, null)
		else: 
			var icon = load(library[index].icon)
			game_list.set_item_icon(index, icon)

func create_register_from_dirs(directories : Array[String]) -> void:
	for directory in directories:
		var dir = DirAccess.open(directory)
		var t_dir = directory + "\\"
		if dir:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if dir.current_is_dir():
					print("Found directory: " + file_name)
				else:
					#print("Found file: " + file_name)
					var extension : String = file_name.get_slice(".",1)
					var title : String = file_name.get_slice(".",0)
					if extension == "exe" or extension == "lnk":
						var tgame = Game.new(title, t_dir + file_name)
						#library.append(tgame)
						print(Global.base_dir + "library//" + title)
						if FileAccess.get_sha256(Global.base_dir + "library//" + title) != "":
							ResourceSaver.save(tgame, Global.base_dir + "library//" + title + ".tres")
				file_name = dir.get_next()
		else:
			print("An error occurred when trying to access the path.")

func load_library_from_register() -> void:
	var directory : String = Global.base_dir + "library//"
	var dir = DirAccess.open(directory)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
				var game = load(directory + file_name) as Game
				library.append(game)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
