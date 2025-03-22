extends Node2D

@onready var personaje_1 : Personaje = %Personaje1
@onready var personaje_2 : Personaje = %Personaje2

@onready var timer_partida = %Reloj

@export var escena_final : PackedScene

func _ready() -> void:
	timer_partida.connect("tiempo_partida_acabado", _on_tiempo_partida_acabado)

func cambiar_escena():
	Transicion.transicion_partida()
	await Transicion.on_transition_finished
	if get_tree():
		get_tree().change_scene_to_packed(escena_final)
		

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
	personaje_1._on_poder_recibido(10)

func _on_personaje_2_ha_bloqueado() -> void:
	$AnimationPlayer.play("bloquear")
	personaje_2._on_poder_recibido(10)

func _on_personaje_1_escudo_roto() -> void:
	$AnimationPlayer.play("escudo_roto")
	personaje_1.romper_escudo()
	personaje_1._on_poder_recibido(-20)

func _on_personaje_2_escudo_roto() -> void:
	$AnimationPlayer.play("escudo_roto")
	personaje_2.romper_escudo()
	personaje_2._on_poder_recibido(10)

func _on_personaje_1_ha_esquivado() -> void:
	$AnimationPlayer.play("esquivar")
	personaje_1._on_poder_recibido(10)

func _on_personaje_2_ha_esquivado() -> void:
	$AnimationPlayer.play("esquivar")
	personaje_2._on_poder_recibido(10)

func _on_timer_poder_timeout() -> void:
	personaje_1._on_poder_recibido(5)
	personaje_2._on_poder_recibido(5)

func _on_tiempo_partida_acabado() -> void:
	

	if personaje_1.salud > personaje_2.salud:
		pass
	elif personaje_1.salud > personaje_2.salud:
		pass
	else:
		pass
	cambiar_escena()
	


func _on_personaje_2_salud_acabada() -> void:
	cambiar_escena()
	


func _on_personaje_1_salud_acabada() -> void:
	cambiar_escena()

func _on_personaje_1_ataque_especial_activado() -> void:
	$AnimationPlayer.play("ataque_especial_p1")


func _on_personaje_2_ataque_especial_activado() -> void:
	$AnimationPlayer.play("ataque_especial_p2")
