extends RigidBody2D


class_name Player

signal died
signal play

const GRAVITY = 18
const MAXIMUM_FLAP_ANGLE = -20 # Degree
const MAXIMUM_FALL_ANGLE = 90 # Degree
const FLAP_VELOCITY = -600

onready var yellow_fly_animation = $YellowFlyAnimation
onready var blue_fly_animation = $BlueFlyAnimation
onready var updown = $Updown
onready var wing_sound = $Wing
onready var die_sound = $Die

onready var saved_game = get_node("/root/SaveGame")

var played = false

var is_started = false
var is_alive = true


func _ready():
	gravity_scale = 0.0
	angular_velocity = 0.0
	if saved_game.getValue("settings", "new_bird") == true:
		blue_fly_animation.show()
		yellow_fly_animation.hide()
		blue_fly_animation.play()
	else:
		yellow_fly_animation.show()
		blue_fly_animation.hide()
		yellow_fly_animation.play()
	updown.play("updown")


func _physics_process(_delta):
	if Input.is_action_just_pressed("flap") and is_alive:
		if not is_started:
			start()
		flap()
	handle_rotation_angle()


func start():
	gravity_scale = GRAVITY
	is_started = true
	updown.stop()
	emit_signal("play")


func flap():
	angular_velocity = -20
	linear_velocity.y = FLAP_VELOCITY
	wing_sound.play()


func handle_rotation_angle():
	#flap angle
	if rotation_degrees < MAXIMUM_FLAP_ANGLE:
		angular_velocity = 0
		rotation_degrees = MAXIMUM_FLAP_ANGLE
		
	#fall angle	
	if linear_velocity.y > 400:
		if rotation_degrees > MAXIMUM_FALL_ANGLE:
			rotation_degrees = MAXIMUM_FALL_ANGLE
			angular_velocity = 0
		else:
			angular_velocity = 15


func die():
	is_alive = false
	yellow_fly_animation.stop()
	blue_fly_animation.stop()
	emit_signal("died")

func get_linear_velocity():
	return linear_velocity.y
