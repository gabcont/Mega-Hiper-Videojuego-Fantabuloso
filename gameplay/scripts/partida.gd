extends Node2D

@onready var personaje_1 : Personaje = %Personaje1
@onready var personaje_2 : Personaje = %Personaje2


func pausar_personajes() -> void:
	personaje_1.pausar()
	personaje_2.pausar()

func reanudar_personajes() -> void:
	personaje_1.reanudar()
	personaje_2.reanudar()

func _on_personaje_1_ha_atacado(tipo_ataque : StringName) -> void:
	personaje_2._on_personaje_atacado(tipo_ataque)


func _on_personaje_2_ha_atacado(tipo_ataque:StringName) -> void:
	personaje_1._on_personaje_atacado(tipo_ataque)


func _on_personaje_1_ha_bloqueado() -> void:
	$AnimationPlayer.play("bloquear")


func _on_personaje_2_ha_bloqueado() -> void:
	$AnimationPlayer.play("bloquear")


func _on_personaje_1_escudo_roto() -> void:
	$AnimationPlayer.play("escudo_roto")
	personaje_1.romper_escudo()


func _on_personaje_2_escudo_roto() -> void:
	$AnimationPlayer.play("escudo_roto")
	personaje_2.romper_escudo()


func _on_personaje_1_ha_esquivado() -> void:
	$AnimationPlayer.play("esquivar")

func _on_personaje_2_ha_esquivado() -> void:
	$AnimationPlayer.play("esquivar")
