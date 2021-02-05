extends PopupPanel

signal adaptive_bg
signal new_bird

onready var saved_game = get_node("/root/SaveGame")


func _ready():
	var togglebutton = get_node("settings/VBoxContainer").get_children()
	var save_settings = saved_game.get_section_keys("settings")
	for i in range (len(togglebutton)):
		togglebutton[i].set_save_toggle(saved_game.getValue("settings", save_settings[i]))


func _on_ToggleSound_toggled(button_pressed):
	if button_pressed:
		AudioServer.set_bus_mute(0, false)
		saved_game.setValue("settings", "sound", true)
	else:
		AudioServer.set_bus_mute(0, true)
		saved_game.setValue("settings", "sound", false)


func _on_ToggleBackground_toggled(button_pressed):
	if button_pressed:
		saved_game.setValue("settings", "adaptive_bg", true)
	else:
		saved_game.setValue("settings", "adaptive_bg", false)
	emit_signal("adaptive_bg")


func _on_ToggleBirds_toggled(button_pressed):
	if button_pressed:
		saved_game.setValue("settings", "new_bird", true)
	else:
		saved_game.setValue("settings", "new_bird", false)
	emit_signal("new_bird")
