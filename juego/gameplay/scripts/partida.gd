extends Node

@onready var personaje_1 : Personaje = %Personaje1
@onready var personaje_2 : Personaje = %Personaje2

@onready var timer_partida = %Reloj
@onready var menu_pausa = $ColorRect
@export var escena_final : PackedScene

func _ready() -> void:
	menu_pausa.hide()
	timer_partida.connect("tiempo_partida_acabado", _on_tiempo_partida_acabado)

	personaje_1.connect("ha_atacado", _on_personaje_ha_atacado)
	personaje_2.connect("ha_atacado", _on_personaje_ha_atacado)

	personaje_1.connect("ha_bloqueado", _on_personaje_ha_bloqueado)
	personaje_2.connect("ha_bloqueado", _on_personaje_ha_bloqueado)

	personaje_1.connect("escudo_roto", _on_personaje_escudo_roto)
	personaje_2.connect("escudo_roto", _on_personaje_escudo_roto)

	personaje_1.connect("ha_esquivado", _on_personaje_ha_esquivado)
	personaje_2.connect("ha_esquivado", _on_personaje_ha_esquivado)

	personaje_1.connect("ataque_especial_activado", _on_ataque_especial_activado)
	personaje_2.connect("ataque_especial_activado", _on_ataque_especial_activado)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pausa"):
		
		menu_pausa.show()
		get_tree().paused = true

func pausar_personajes() -> void:
	personaje_1.pausar()
	personaje_2.pausar()

func reanudar_personajes() -> void:
	personaje_1.reanudar()
	personaje_2.reanudar()

func _on_personaje_ha_atacado(es_p1 : bool, tipo_ataque : StringName):
	var personaje_atacado = personaje_1
	if es_p1:
		personaje_atacado = personaje_2
	personaje_atacado.ataque_a_buffer(tipo_ataque)

func _on_personaje_ha_bloqueado(es_p1 : bool):
	var personaje = personaje_1
	if not es_p1:
		personaje = personaje_2

	$AnimationPlayer.play("bloquear")
	personaje.cargar_poder(10)

func _on_personaje_escudo_roto(es_p1 : bool):
	var personaje = personaje_1
	if not es_p1:
		personaje = personaje_2

	$AnimationPlayer.play("escudo_roto")
	personaje.romper_escudo()
	personaje.cargar_poder(-20)

func _on_personaje_ha_esquivado(es_p1 : bool):
	var personaje = personaje_1
	if not es_p1:
		personaje = personaje_2

	$AnimationPlayer.play("esquivar")
	personaje.cargar_poder(10)

func _on_ataque_especial_activado(es_p1: bool) -> void:
	if es_p1:
		$AnimationPlayer.play("ataque_especial_p1")
	else:
		$AnimationPlayer.play("ataque_especial_p2")

func _on_timer_poder_timeout() -> void:
	personaje_1.cargar_poder(5)
	personaje_2.cargar_poder(5)

func _on_tiempo_partida_acabado() -> void:
	if personaje_1.salud > personaje_2.salud:
		pass
	elif personaje_1.salud > personaje_2.salud:
		pass
	else:
		pass

func _on_personaje_2_salud_acabada() -> void:
	pass

func _on_personaje_1_salud_acabada() -> void:
	pass
