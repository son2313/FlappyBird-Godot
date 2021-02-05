extends Node2D

onready var base = $Base
onready var night_bg = $"background-night"
onready var obstacles_spawner = $ObstaclesSpawner
onready var hud = $HUD
onready var player = $Player
onready var message = $message
onready var game_over_layer = $GameOverLayer
onready var fade = $Fade
onready var fade_animation = $Fade/FadeAnimation
onready var hit = $Hit
onready var hit_animation = $Hit/HitAnimation

onready var player_die_sound = $Player/Die
onready var player_hit_sound = $Player/Hit
onready var player_point_sound = $Player/Point


var is_game_over_sound = false
var is_game_over_ani = false
var is_high_score = false

onready var saved_game = get_node("/root/SaveGame")
var score = 0 setget set_score
var highscore = 0


func _ready():
	hud.update_score(score)
	
	if not (saved_game.getValue("settings", "adaptive_bg") == true and OS.get_time().hour > 15):
		night_bg.hide()
	
	base.play()
	fade_animation.play("animation")
	yield(fade_animation, "animation_finished")
	
	fade.hide()
	hit.hide()
	obstacles_spawner.connect("obstacles_created", self, "_on_ObstaclesSpawner_obstacle_created")
	highscore = saved_game.getValue("score", "highscore")


func _on_ObstaclesSpawner_obstacle_created(obstacle):
	obstacle.connect("score", self, "scored")


func scored():
	if not is_game_over_sound:
		player_point_sound.play()
		self.score += 1


func set_score(new_score):
	score = new_score
	hud.update_score(score)


func _on_Player_play():
	obstacles_spawner.start()
	message.hide()


func _on_Player_died():
	game_over()


func game_over():
	get_tree().call_group("Obstacles", "set_physics_process", false)
	obstacles_spawner.stop()
	base.stop()
	
	handle_sound_die()
	
	#show game over panel and medal
	if not is_game_over_ani:
		if score > highscore:
			highscore = score
			is_high_score = true
			saved_game.setValue("score", "highscore", highscore)
		
		game_over_layer.connect("restart", self, "restart_world")
		
		hit.show()
		hit_animation.play("animation")
	
		hud.hide()
		game_over_layer.update_score(score, highscore, is_high_score)
		game_over_layer.update_medal(score)
		game_over_layer.play_animation()
		is_game_over_ani = true


func handle_sound_die():
	if not is_game_over_sound:
		is_game_over_sound = true
		player_hit_sound.play()
		yield(player_hit_sound,"finished")
		if player.get_linear_velocity() > 2:
			player_die_sound.play()


func restart_world():
	get_tree().reload_current_scene()
