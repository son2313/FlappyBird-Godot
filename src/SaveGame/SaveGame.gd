extends Node2D 

var save_path = "res://save.cfg"
var config = ConfigFile.new()
var load_response = config.load(save_path)


func _ready():
	pass


func setValue(section, key, value):
	config.set_value(section, key, value)
	config.save(save_path)


func getValue(section, key):
	return config.get_value(section, key, -1)

func get_section_keys(section):
	return config.get_section_keys(section)
