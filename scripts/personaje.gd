extends Node2D

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var animacion_player : AnimationPlayer = $AnimationPlayer

func play_animacion(animacion : String) -> void:
	match animacion:
		"huida":
			animacion_player.play(animacion)
		
	sprite.play(animacion)
	$Sonido.play_sfx(animacion)

func _on_animated_sprite_2d_animation_finished() -> void:
	sprite.play("idle")
