extends Node

var fileName = "user://store_app_data.res"
var DATA = {}
var default = {
	"prestige": 0,
	"expedition": 0,
	"ended_tabern_tuto": false,
	"items_unlocked":["dage"],
	"items_preselected":[],
	"characters_preselected":[],
	"characters_unlocked":[1,4,5,7],
	"languaje": "en"
}

func _ready():
	load_store_data()

func _set_defaults():
	for k in default.keys(): 
		if !k in DATA: DATA[k] = default[k]

func save_store_data():
	_set_defaults()
	for k in default.keys(): if !k in DATA: DATA[k] = default[k]
	var file := FileAccess.open(fileName, FileAccess.WRITE)
	if !file: return
	DATA["languaje"] = Lang.current_lang
	file.store_string(JSON.stringify(DATA))
	print("SAVE ",DATA)

func load_store_data(): 
	if !FileAccess.file_exists(fileName): save_store_data()
	var file = FileAccess.open(fileName, FileAccess.READ)
	var loaded_data = JSON.parse_string(file.get_as_text())
	if loaded_data: DATA = loaded_data
	_set_defaults()
	Lang.current_lang = DATA["languaje"]
	print("LOAD ",DATA)

func now_date():
	var now = Time.get_datetime_dict_from_system()
	return str(now.year)+"-"+str(now.month)+"-"+str(now.day)+" "+str(now.hour)+":"+str(now.minute)

func clear_data():
	DATA = {}
	save_store_data()
	GameManager.change_scene("Menu")
