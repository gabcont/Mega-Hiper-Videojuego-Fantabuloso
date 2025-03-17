extends Node2D

@onready var personaje_1 : Personaje = $Personajes/Personaje1
@onready var personaje_2 : Personaje = $Personajes/Personaje2



func _on_personaje_1_ha_atacado(tipo_ataque : StringName) -> void:
	personaje_2.procesar_ataque_enemigo(tipo_ataque)


func _on_personaje_2_ha_atacado(tipo_ataque:StringName) -> void:
	personaje_1.procesar_ataque_enemigo(tipo_ataque)
