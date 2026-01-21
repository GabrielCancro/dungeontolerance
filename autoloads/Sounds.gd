extends Node

var scene
var music_stream
enum BUS {MASTER, SFX, MUSIC}

func _ready():
	load("res://assets/sounds/music01.ogg")
	load("res://assets/sounds/ambient.mp3")
	AudioServer.add_bus(BUS.SFX)
	AudioServer.add_bus(BUS.MUSIC)
	music_stream = AudioStreamPlayer.new()
	music_stream.bus = AudioServer.get_bus_name(BUS.MUSIC)
	add_child(music_stream)
	set_master_vol(100)
	set_sfx_vol(100)
	set_music_vol(70)

func set_audio_scene(_scene):
	scene = _scene

func play_sound(id):
	var audio = AudioStreamPlayer.new()
	audio.bus = AudioServer.get_bus_name(BUS.SFX)
	add_child(audio)
	audio.stream = load("res://assets/sounds/"+id+".ogg")
	audio.stream.loop = false
	audio.play()
	await audio.finished
	if is_instance_valid(audio): audio.queue_free()

func play_music(id):
	music_stream.stream = load("res://assets/sounds/"+id+".ogg")
	music_stream.stream.loop = true
	music_stream.play()

func set_master_vol(val):
	var db = (val-100)*0.33
	AudioServer.set_bus_volume_db(BUS.MASTER, db )
	AudioServer.set_bus_mute(BUS.MASTER, (val==0) )

func set_music_vol(val):
	var db = (val-100)*0.33
	AudioServer.set_bus_volume_db(BUS.MUSIC, db )
	AudioServer.set_bus_mute(BUS.MUSIC, (val==0) )

func set_sfx_vol(val):
	var db = (val-100)*0.33
	var bus_index = AudioServer.get_bus_index("Sfx")
	AudioServer.set_bus_volume_db(BUS.SFX, db )
	AudioServer.set_bus_mute(BUS.SFX, (val==0) )
