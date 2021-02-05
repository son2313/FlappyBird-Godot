extends Sprite


onready var score_board_tween = $ScoreBoardTween


func _ready():
	score_board_tween.interpolate_property(self, "position", position, Vector2(300, 410), 1, Tween.TRANS_QUINT, Tween.EASE_OUT)
