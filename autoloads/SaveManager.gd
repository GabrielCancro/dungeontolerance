extends Node

var fileName = "user://store_app_data.res"
var DATA = {}

func _ready():
	load_store_data()

func _set_defaults():
	DATA["language"] = Lang.current_lang
	DATA["save_date"] = now_date()
	if !"prestige" in DATA: DATA["prestige"] = 0
	if !"expedition" in DATA: DATA["expedition"] = 0

func save_store_data():
	_set_defaults()
	var file := FileAccess.open(fileName, FileAccess.WRITE)
	if !file: return
	file.store_string(JSON.stringify(DATA))
	print("SAVE ",DATA)

func load_store_data(): 
	if !FileAccess.file_exists(fileName): save_store_data()
	var file = FileAccess.open(fileName, FileAccess.READ)
	var loaded_data = JSON.parse_string(file.get_as_text())
	if loaded_data: DATA = loaded_data
	_set_defaults()
	print("LOAD ",DATA)

func now_date():
	var now = Time.get_datetime_dict_from_system()
	return str(now.year)+"-"+str(now.month)+"-"+str(now.day)+" "+str(now.hour)+":"+str(now.minute)

func clear_data():
	DATA = {}
	get_tree().change_scene("res://scenes/Intro.tscn")
