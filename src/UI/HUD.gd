extends Node2D


var number_img = []
const NUMER_IMG_SIZE = Vector2(24*1.3, 36*1.3)
const MIDDLE_POS = Vector2(300, 150)
const LETTER_SPACING = 8


func _ready():
	load_img()


func update_score(score):
	#remove old score
	for i in get_children():
		remove_child(i)
		i.queue_free()
	
	var str_score = str(score)
	var n = len(str_score)
	var one = 0
	
	for i in range(n):
		one += int(str_score[i] == '1')
			
	var right = MIDDLE_POS.x + (((n - one) * NUMER_IMG_SIZE.x + (n - 1)*LETTER_SPACING + one*16*1.3)/2)
	var current_pos_x = right
	var previous_size_x = 0
	var current_size_x = 0	
	for i in range(n - 1, -1, -1):
		var new_sprite = Sprite.new()
		new_sprite.set_texture(number_img[int(str_score[i])])
		add_child(new_sprite)
		new_sprite.scale = Vector2(1.3, 1.3)
		if i == n - 1:
			if str_score[i] == '1':
				previous_size_x = 20.8
				current_pos_x -= 10.4
			else:
				previous_size_x = NUMER_IMG_SIZE.x
				current_pos_x -= NUMER_IMG_SIZE.x/2
		else:
			if str_score[i] == '1':
				current_size_x = 20.8
			else:
				current_size_x = NUMER_IMG_SIZE.x
			current_pos_x -= previous_size_x/2 + LETTER_SPACING + current_size_x/2
			previous_size_x = current_size_x
		new_sprite.position = Vector2(current_pos_x, MIDDLE_POS.y)


func load_img():
	var img_dir = Directory.new()
	img_dir.open("res://assets/img")
	img_dir.list_dir_begin(true)
	
	for i in range(0, 10):
		number_img.append(load("res://assets/img/" + str(i) + ".png"))
		img_dir.get_next()
