extends CanvasLayer


onready var start_press_ani = $StartMenu/PlayButton/StartPressAnimation
onready var setting_press_ani = $StartMenu/SettingButton/SettingPressAnimation
onready var fade = $Fade

onready var fade_animation = $Fade/FadeAnimation
onready var social_button_animation = $StartMenu/HBoxContainer/SocialButtonAnimation

onready var night_bg = $"background-night"
onready var saved_game = get_node("/root/SaveGame")
onready var setting_panel = $StartMenu/SettingPanelLayer

onready var blue_bird= $StartMenu/StartMessage/BlueBird
onready var yellow_bird = $StartMenu/StartMessage/YellowBird
var started = false


func _ready():
	yellow_bird.play()
	blue_bird.play()
	#initial bg
	if not(saved_game.getValue("settings", "adaptive_bg") == true and OS.get_time().hour >= 18):
		night_bg.hide()
		
	#initial color bird
	if saved_game.getValue("settings", "new_bird") == true:
		yellow_bird.hide()
	else:
		blue_bird.hide()
	
	fade_animation.play("fade_in")
	yield(fade_animation, "animation_finished")
	fade.hide()


func _on_SettingPanelLayer_adaptive_bg():
	if saved_game != null:
		if saved_game.getValue("settings", "adaptive_bg") == true and OS.get_time().hour >= 18:
			night_bg.show()
		else:
			night_bg.hide()


func _on_SettingPanelLayer_new_bird():
	if saved_game != null:
		if saved_game.getValue("settings", "new_bird") == true:
			yellow_bird.hide()
			blue_bird.show()
		else:
			blue_bird.hide()
			yellow_bird.show()
			


func _on_PlayButton_button_down():
	start_press_ani.play("press")
	start_press_ani.queue("pressing")


func _on_PlayButton_button_up():
	start_press_ani.play("release")
	fade.show()
	fade_animation.play("fade_out")
	yield(fade_animation, "animation_finished")
	get_tree().change_scene("res://src/World/World.tscn")


func _on_SettingButton_button_down():
	setting_press_ani.play("press")
	setting_press_ani.queue("pressing")


func _on_SettingButton_button_up():
	setting_press_ani.play("release")
	setting_panel.popup()


func _on_GoogleButton_button_down():
	social_button_animation.play("google_press")
	social_button_animation.queue("google_pressing")


func _on_GoogleButton_button_up():
	social_button_animation.play("google_release")
	OS.shell_open("https://mail.google.com/mail/u/0/?view=cm&fs=1&to=hoangsonngo555@gmail.com&tf=1")


func _on_FacebookButton_button_down():
	social_button_animation.play("facebook_press")
	social_button_animation.queue("facebook_pressing")


func _on_FacebookButton_button_up():
	social_button_animation.play("facebook_release")
	OS.shell_open("https://www.facebook.com/HoangSon2313")


func _on_TelegramButton_button_down():
	social_button_animation.play("telegram_press")
	social_button_animation.queue("telegram_pressing")


func _on_TelegramButton_button_up():
	social_button_animation.play("telegram_release")
	OS.shell_open("https://t.me/hoangson2313")


func _on_DiscordButton_button_down():
	social_button_animation.play("discord_press")
	social_button_animation.queue("discord_pressing")


func _on_DiscordButton_button_up():
	social_button_animation.play("discord_release")
