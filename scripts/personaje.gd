class_name Personaje extends Node2D

signal ha_atacado(tipo_ataque : StringName)

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@export var nodo_botones : Node2D
@export var voltear_personaje : bool = false
@export var spriteframe : SpriteFrames

var salud : int = 200
var frame_actual_de_animacion : int 

var ESTADO_ACTUAL : StringName = "IDLE"
var PUEDE_SER_ATACADO : bool = true
var PUEDE_RECIBIR_INPUT : bool = true
var ESTADO_PUEDE_SER_INTERRUMPIDO : bool = true

var input_buffer : StringName = "vacio"

func _process(_delta: float) -> void:
	actualizar_debug_info()

func _ready() -> void:
	# Carga sprites del personaje
	sprite.sprite_frames = spriteframe

	# Cambia al estado inicial
	ESTADO_ACTUAL = "idle"
	sprite.play("idle")

	# Voltea sprite del personaje si esta en la parte izq de la pantalla
	if voltear_personaje:
		voltear_sprite()
	
	# Conecta los botones con las acciones del personaje
	var botones := nodo_botones.get_children()
	for boton in botones:
		boton.connect("boton_presionado", _on_boton_presionado)

func set_estado(estado : StringName) -> void:
	ESTADO_ACTUAL = estado

func set_puede_ser_atacado(valor : bool) -> void:
	PUEDE_SER_ATACADO = valor

func set_puede_recibir_input(valor : bool) -> void:
	PUEDE_RECIBIR_INPUT = valor

# Actualiza textos en pantalla con información del personaje
func actualizar_debug_info() -> void:
	$Debug/Estado.text = ESTADO_ACTUAL
	$Debug/Atacado.text = "PUEDE SER ATACADO = " + str(PUEDE_SER_ATACADO).to_upper()
	$Debug/Interrumpido.text = "PUEDE SER INTERRUMPIDO = " + str(ESTADO_PUEDE_SER_INTERRUMPIDO).to_upper()
	$Debug/Input.text = "PUEDE RECIBIR INPUT = " + str(PUEDE_RECIBIR_INPUT).to_upper()
	$Debug/Salud.text = "Salud = " + str(salud)
	$Debug/Frame.text = "Frame = " + str(frame_actual_de_animacion)

# Cambia animación del sprite según la acción a realizar
func play_animacion(accion : StringName) -> void:
	var animacion : StringName
	match accion:
		"ataque_debil":
			if randi_range(1, 2) == 1:
				animacion = "ataque_debil_1"
			else:
				animacion = "ataque_debil_2"

		"ataque_fuerte":
			animacion = "ataque_fuerte"

		"esquivar":
			animacion = "esquivar"
			if voltear_personaje:
				animacion += "_volteado"
			
		"bloquear":
			animacion = "bloquear"

		"herido":
			animacion = "herido"
	animation_player.play(animacion)

# Se explica solo
func voltear_sprite() -> void:
	sprite.flip_h = not sprite.flip_h
	$PosMitadSprite.position = Vector2(80, 0)
	$PosMitadSprite/Burbuja.rotation = PI

func procesar_input() -> void:
	if PUEDE_RECIBIR_INPUT and input_buffer != "vacio":
		match ESTADO_ACTUAL:
			"ataque_fuerte":
				if input_buffer == "esquivar":
					# amague
					pass
				elif input_buffer == "ataque_debil":
					# ataque especial
					pass
			_:
				play_animacion(input_buffer)

func borrar_input_buffer() -> void:
	input_buffer = "vacio"

# Se activa cuando un boton es presionado, recibe texto del boton
func _on_boton_presionado(nombre_accion : StringName) -> void:
	input_buffer = nombre_accion

func _on_animated_sprite_2d_animation_finished() -> void:
	ESTADO_ACTUAL = "idle"
	sprite.play("idle")


func _on_animated_sprite_2d_frame_changed() -> void:
	frame_actual_de_animacion += 1

	procesar_input()
	borrar_input_buffer()

	match ESTADO_ACTUAL:
		"ataque_debil":
			if frame_actual_de_animacion > 4:
				frame_actual_de_animacion = 1
		"ataque_fuerte":
			if frame_actual_de_animacion > 7:
				frame_actual_de_animacion = 1
		"esquivar":
			if frame_actual_de_animacion > 4:
				frame_actual_de_animacion = 1
		"bloquear":
			if frame_actual_de_animacion > 2:
				frame_actual_de_animacion = 1
		"idle":
			if frame_actual_de_animacion > 7:
				frame_actual_de_animacion = 1

func _on_animation_player_current_animation_changed() -> void:
	frame_actual_de_animacion = 1

func procesar_ataque_enemigo(tipo_ataque : StringName) -> void:
	match tipo_ataque:
		"ataque_debil":
			if ESTADO_ACTUAL == "bloquear":
				pass
			elif ESTADO_ACTUAL == "esquivar" and not PUEDE_SER_ATACADO:
				pass
			else:
				salud -= 20
				play_animacion("herido")
		"ataque_fuerte":
			if ESTADO_ACTUAL == "esquivar":
				pass
			else:
				salud -= 30
				play_animacion("herido")
	
func atacar() -> void:
	ha_atacado.emit(ESTADO_ACTUAL)
