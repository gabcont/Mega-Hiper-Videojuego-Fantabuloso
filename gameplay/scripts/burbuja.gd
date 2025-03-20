extends Node2D

func _ready() -> void:
	reset()

func reset() -> void:
	ocultar()
	$AnimacionBurbuja.play("RESET")

func romper_escudo() -> void:
	$AnimacionBurbuja.play("escudo_roto")

func _on_animacion_burbuja_animation_finished(_anim_name : StringName) -> void:
	if _anim_name == "escudo_roto":
		reset()
	
func voltear() -> void:
	%Burbuja.flip_h = not %Burbuja.flip_h

func ocultar() -> void:
	visible = false

func mostrar() -> void:
	visible = true
