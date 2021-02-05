extends Node2D

signal score

const OBSTACLES_VELOCITY = -210

func _ready():
	pass


func _physics_process(delta):
	position.x += OBSTACLES_VELOCITY * delta
	if position.x < -700:
		queue_free()


func _on_Obstacles_body_entered(body):
	if body is Player:
		if body.has_method("die"):
			body.die()


func _on_ScoreArea_body_exited(body):
	if body is Player:
		emit_signal("score")
