extends CheckButton


onready var toggle_animation_tree = $ToggleAnimationTree


func _ready():
	pass

func set_save_toggle(toggled):
	pressed = toggled
	if toggled:
		toggle_animation_tree['parameters/playback'].start('toggle_on')
	else:
		toggle_animation_tree['parameters/playback'].start('toggle_off')
