extends Node

@onready var personaje_1 : Personaje = %Personaje1
@onready var personaje_2 : Personaje = %Personaje2

@onready var statusLabel = %Final.get_node("MenuFinal/CenterContainer/VBoxContainer/Label")
@onready var timer_partida = %Reloj
@onready var animation_player = $AnimationPlayer
# @onready var menu_pausa = $ColorRect

@export var escena_final : PackedScene
@export var escena_pausa : PackedScene

var tiempo_partida : int = 60;

var path_carpeta_fondos = "res://juego/Fondo/escenas/"

func _ready() -> void:
	var _datos_partida = ConfigPartida.obtener_partida_actual()
	var nombre_personaje_1 = _datos_partida.pop_front()
	var nombre_personaje_2 = _datos_partida.pop_front()
	var nombre_escenario = _datos_partida.pop_front()

	set_personajes(nombre_personaje_1, nombre_personaje_2)
	set_fondo(nombre_escenario)
	
	$HUD/BarrasVida.actualizar_nombres()

	if ConfigPartida.modo_juego_actual != ConfigPartida.ModoJuego.VS_JUGADOR:
		personaje_2.set_es_ia(true)

	timer_partida.connect("tiempo_partida_acabado", _on_tiempo_partida_acabado)
	animation_player.connect("current_animation_changed", _on_animation_changed)

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

	personaje_1.connect("salud_acabada", _on_personaje_1_salud_acabada)
	personaje_2.connect("salud_acabada", _on_personaje_2_salud_acabada)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Pausa"):
		var pausa : Control = escena_pausa.instantiate()
		pausa.z_index = 5
		add_child(pausa)

func _on_animation_changed(animation : String) -> void:
	if animation.begins_with("ataque_especial"):
		pass #animation_player.play("RESET")

func set_personajes(nombre_personaje_1 : String, nombre_personaje_2 : String) -> void:
	personaje_1.set_personaje(nombre_personaje_1)
	personaje_2.set_personaje(nombre_personaje_2)

func set_fondo(_nombre_fondo : String) -> void:
	var escena_fondo : PackedScene = load(path_carpeta_fondos + _nombre_fondo + ".tscn")
	$Fondo.add_child(escena_fondo.instantiate())

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
	finalizar_partida()
	if personaje_1.salud > personaje_2.salud:
		statusLabel.text = "Jugador 1 gano"
		Db.registrar_partida(1, tiempo_partida - ConfigPartida.tiempo)

	elif personaje_1.salud < personaje_2.salud:
		statusLabel.text = "Jugador 2 gano"
		Db.registrar_partida(2, tiempo_partida - ConfigPartida.tiempo)

	else:
		var numero_ganador =  randi_range(1, 2)
		statusLabel.text = "Jugador 1 gano" if numero_ganador==1 else "Jugador 2 gano"
		Db.registrar_partida(numero_ganador, tiempo_partida - ConfigPartida.tiempo)

func _on_personaje_2_salud_acabada(_ignorar) -> void:
	finalizar_partida()
	statusLabel.text = "Jugador 1 gano"
	Db.registrar_partida(1, tiempo_partida - ConfigPartida.tiempo)

func _on_personaje_1_salud_acabada(_ignorar) -> void:
	finalizar_partida()
	statusLabel.text = "Jugador 2 gano"
	Db.registrar_partida(2, tiempo_partida - ConfigPartida.tiempo)

func finalizar_partida() -> void:
	#pausar_personajes()
	$HUD.hide()
	%Final.show()
	ConfigPartida.siguiente_partida()
	if ConfigPartida.queue_partida_vacio():
		%MenuFinal.show()
	else:
		%MenuContinuar.show()
	
