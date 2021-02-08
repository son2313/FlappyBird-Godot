extends CanvasLayer

signal restart

onready var game_over_message = $GameOverMessage
onready var score_board = $ScoreBoard
onready var score_ui = $ScoreUI
onready var control = $Control
onready var fade = $Fade

onready var message_animation = $GameOverMessage/MessageAnimation
onready var score_board_animation = $ScoreBoard/ScoreBoardTween
onready var fade_animation = $Fade/FadeAnimation

onready var ok_animation = $Control/OkButton/OkAnimation
onready var restart_animation = $Control/RestartButton/RestartAnimation

onready var score_board_sound = $ScoreBoard/ScoreBoardSound

var number_img = []
var medal_img
var highscore_img
const LETTER_SPACING = 5
const NUMER_IMG_SIZE = Vector2(24, 36)
const RIGHT_MOST_POS_SCORE = Vector2(436, 982)# 710 765
const RIGHT_MOST_POS_HIGHSCORE = Vector2(436, 1048)

var is_medal = false

func _ready():
	game_over_message.hide()
	score_board.hide()
	score_board.get_node("Medal").hide()
	score_board.get_node("New").hide()
	control.hide()
	fade.hide()
	load_img()


func play_animation():
	game_over_message.show()
	score_board.show()
	control.show()
	message_animation.play("animation")
	yield(message_animation, "animation_finished")
	
	for i in score_ui.get_children():
		i.get_child(0).start()
	
	score_board_sound.play()
	score_board_animation.start()
	yield(score_board_animation, "tween_all_completed")
	
	score_board.get_node("Medal").show()
	score_board.get_node("New").show()
	if is_medal:
		score_board.get_node("SpakleAnimation").play("animation")

	ok_animation.play("appear")
	restart_animation.play("appear")


func _on_RestartButton_button_down():
	restart_animation.play("press")
	restart_animation.queue("pressing")


func _on_RestartButton_button_up():
	fade.show()
	restart_animation.play("release")
	fade_animation.play("animation")
	yield(fade_animation, "animation_finished")
	emit_signal("restart")


func _on_OkButton_button_down():
	ok_animation.play("press")
	ok_animation.queue("pressing")


func _on_OkButton_button_up():
	fade.show()
	ok_animation.play("release")
	fade_animation.play("animation")
	yield(fade_animation, "animation_finished")
	get_tree().change_scene("res://src/UI/MenuLayer.tscn")


func load_img():
	var img_dir = Directory.new()
	img_dir.open("res://assets/img")
	img_dir.list_dir_begin(true)
	
	highscore_img = load("res://assets/img/new.png")
	
	for i in range(0, 10):
		number_img.append(load("res://assets/img/" + str(i) + ".png"))
		img_dir.get_next()


func update_score(score, high_score, is_highscore):
	var str_score = str(score)
	var str_highscore = str(high_score)
	var n_score = len(str_score)
	var n_highscore = len(str_highscore)
	
	if is_highscore:
		score_board.get_node("New").set_texture(highscore_img)
	
	var current_pos_x = RIGHT_MOST_POS_SCORE.x
	var previous_size_x = 0
	var current_size_x = 0
	
	for i in range(n_score - 1, -1, -1):
		var new_sprite = Sprite.new()
		var tween = Tween.new()
		score_ui.add_child(new_sprite)
		new_sprite.add_child(tween)
		new_sprite.set_texture(number_img[int(str_score[i])])
		if i == n_score - 1:
			if str_score[i] == '1':
				previous_size_x = 16
			else:
				previous_size_x = NUMER_IMG_SIZE.x
		else:
			if str_score[i] == '1':
				current_size_x = 16
			else:
				current_size_x = NUMER_IMG_SIZE.x
			current_pos_x -= previous_size_x/2 + LETTER_SPACING + current_size_x/2
			previous_size_x = current_size_x
		
		new_sprite.position = Vector2(current_pos_x, RIGHT_MOST_POS_SCORE.y)
		tween.interpolate_property(new_sprite, "position", new_sprite.position, Vector2(new_sprite.position.x, 392), 1, Tween.TRANS_QUINT, Tween.EASE_OUT)
	
	current_pos_x = RIGHT_MOST_POS_HIGHSCORE.x
	previous_size_x = 0
	current_size_x = 0
	for i in range(n_highscore - 1, -1, -1):
		var new_sprite = Sprite.new()
		var tween = Tween.new()
		score_ui.add_child(new_sprite)
		new_sprite.add_child(tween)
		new_sprite.set_texture(number_img[int(str_highscore[i])])
		if i == n_score - 1:
			if str_score[i] == '1':
				previous_size_x = 16
			else:
				previous_size_x = NUMER_IMG_SIZE.x
		else:
			if str_score[i] == '1':
				current_size_x = 16
			else:
				current_size_x = NUMER_IMG_SIZE.x
			current_pos_x -= previous_size_x/2 + LETTER_SPACING + current_size_x/2
			previous_size_x = current_size_x
		
		new_sprite.position = Vector2(current_pos_x, RIGHT_MOST_POS_HIGHSCORE.y)
		tween.interpolate_property(new_sprite, "position", new_sprite.position, Vector2(new_sprite.position.x,458), 1, Tween.TRANS_QUINT, Tween.EASE_OUT)


func update_medal(score):
	if score > 9:
		is_medal = true
	if score > 9 and score < 50:
		medal_img = load("res://assets/img/coppermedal.png")
	elif score > 49 and score < 100:
		medal_img = load("res://assets/img/silvermedal.png")
	elif score > 99 and score < 500:
		medal_img = load("res://assets/img/goldmedal.png")
	elif score > 499:
		medal_img = load("res://assets/img/platinummedal.png")
	var medal = get_node("ScoreBoard/Medal")
	medal.set_texture(medal_img)
	medal.scale = Vector2(1.5, 1.5)
