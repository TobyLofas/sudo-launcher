extends Control

@onready var game_list = %GameList
@onready var detail_panel = %DetailPanel
@onready var top_bar = %TopBar

var library : Array[Game] = []
var filtered_library : Array[Game] = []
var selected : Game
var tags : Array = []

var _search_filtered : Array[Game]
var _tag_filtered : Array[Game]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var data = load(Global.base_dir + "tags.csv")
	if data: tags = data.records ##ADD SYSTEM TO CREATE TAGS.CSV IF NONE EXISTS
	top_bar.search_bar.text_changed.connect(filter_by_search)
	top_bar.tags_changed.connect(filter_by_tag)
	top_bar.image_toggle.toggled.connect(toggle_images)
	detail_panel.play_button.pressed.connect(play_game)
	create_register_from_dirs(["C:\\Users\\tobyl\\Desktop\\Games"])
	load_library_from_register()
	refresh_game_list()
	_on_game_list_item_selected(0)
	
func build(directories : Array[String]) -> void:
	create_register_from_dirs(directories)
	load_library_from_register()
	refresh_game_list()
	_on_game_list_item_selected(0)

func create_game_list_from_library() -> void:
	game_list.clear()
	for item in library:
		game_list.add_item(item.name, load(item.icon))

func _on_game_list_item_selected(index: int) -> void:
	selected = filtered_library[index]
	detail_panel._refresh_from_data(selected)

func filter_by_search(term : String) -> void:
	_search_filtered = []
	if term == "":
		create_game_list_from_filtered_library()
	else:
		game_list.clear()
		for item in library:
			if item.name.containsn(term):
				_search_filtered.append(item)
	refresh_game_list()

func filter_by_tag(_tags : Array[String]) -> void:
	_tag_filtered = []
	if _tags.is_empty():
		create_game_list_from_filtered_library()
	else:
		game_list.clear()
		for item in library:
			for tag in _tags:
				if tag in item.tags:
					_tag_filtered.append(item)
	refresh_game_list()

func refresh_game_list() -> void:
	_apply_filters()
	_apply_ordering()

func _apply_filters() -> void:
	filtered_library = []
	if (_search_filtered != [] and _tag_filtered != []):
		for s_item in _search_filtered:
			for t_item in _tag_filtered:
				if t_item == s_item:
					filtered_library.append(t_item)
	elif (_search_filtered != []):
		for s_item in _search_filtered:
			filtered_library.append(s_item)
	elif (_tag_filtered != []):
		for t_item in _tag_filtered:
			filtered_library.append(t_item)
	else:
		if top_bar.search_bar.text == "":
			filtered_library = library
			
	create_game_list_from_filtered_library()

func _apply_ordering() -> void:
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
		var t_dir : String = directory + "\\"
		if !dir:
			print("An error occurred when trying to access the path.")
		else:
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
						var tgame : Game = Game.new(title, t_dir + file_name)
						var library_path = Global.base_dir + Global.library_dir + title
						if FileAccess.get_sha256(library_path + ".tres") == "":
							ResourceSaver.save(tgame, library_path + ".tres")
				file_name = dir.get_next()

func load_library_from_register() -> void:
	var directory : String = Global.base_dir + Global.library_dir
	var dir = DirAccess.open(directory)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				#print("Found file: " + file_name)
				var extension : String = file_name.get_slice(".",1)
				if extension == "tres":
					var game : Game = load(directory + file_name) as Game
					library.append(game)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func play_game() -> void:
	#var args : Array[String] = []
	OS.create_process("cmd.exe", ["/c", selected.path])
