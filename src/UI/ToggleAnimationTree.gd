extends AnimationTree


func _ready():
	active = true


func _on_ToggleButton_toggled(button_pressed):
	if button_pressed:
		self['parameters/playback'].travel('toggle_on')
	else:
		self['parameters/playback'].travel('toggle_off')
