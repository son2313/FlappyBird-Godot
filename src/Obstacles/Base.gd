extends StaticBody2D

onready var animator = $base/AnimationPlayer

func _ready():
	pass # Replace with function body.


func _on_Deadzone_body_entered(body):
	if body is Player:
		if body.has_method("die"):
			body.die()


func play():
	animator.play("Base")


func stop():
	animator.stop()
