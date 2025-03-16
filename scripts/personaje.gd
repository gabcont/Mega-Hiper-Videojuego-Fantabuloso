extends Node2D

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var animacion_player : AnimationPlayer = $AnimationPlayer
@export var nodo_botones : Node2D
@export var voltear_personaje : bool = false


func _ready() -> void:
	if voltear_personaje:
		voltear_sprite()
	var botones := nodo_botones.get_children()
	for boton in botones:
		boton.connect("boton_presionado", _on_boton_presionado)

func play_animacion(accion : String) -> void:
	var animacion : String
	match accion:
		"ataque_debil":
			if randi_range(1, 2) == 1:
				animacion = "ataque_1"
			else:
				animacion = "ataque_2"

		"ataque_fuerte":
			animacion = "ataque_especial"

		"esquivar":
			animacion = "esquivar"
			if voltear_personaje:
				animacion_player.play(animacion + "_volteado")
			else:
				animacion_player.play(animacion)

	sprite.play(animacion)
	$Sonido.play_sfx(animacion)

func _on_animated_sprite_2d_animation_finished() -> void:
	sprite.play("idle")

func voltear_sprite() -> void:
	sprite.flip_h = not sprite.flip_h

func _on_boton_presionado(nombre_boton) -> void:
	play_animacion(nombre_boton)
