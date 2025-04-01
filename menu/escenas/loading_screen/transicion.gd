extends CanvasLayer

signal faded_out

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

func _ready():
	color_rect.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)
		
func _on_animation_finished(anim_name):
	if anim_name == "fade_out":
		faded_out.emit()

func transicion():
	color_rect.visible = true
	animation_player.play("fade_in")

		
	
