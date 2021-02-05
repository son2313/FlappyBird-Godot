extends Node2D

signal obstacles_created(obstacle)

var Obstacles= preload("res://src/Obstacles/Obstacles.tscn")

onready var timer = $Timer


func _ready():
	pass # Replace with function body.


func _on_Timer_timeout():
	spawn_obstacles()


func spawn_obstacles():
	var new_obstacle = Obstacles.instance()
	add_child(new_obstacle)
	new_obstacle.position.y = randi()%300 + 0
	emit_signal("obstacles_created", new_obstacle)


func start():
	timer.start()


func stop():
	timer.stop()
