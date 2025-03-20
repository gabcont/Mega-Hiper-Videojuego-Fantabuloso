class_name Personaje extends Node2D

signal ha_atacado(tipo_ataque : StringName)
signal ha_esquivado
signal ha_bloqueado
signal escudo_roto
signal salud_acabada

const SALUD_MAXIMA : int = 400
var salud : int = SALUD_MAXIMA

const PODER_MAXIMO : int = 100
var poder : int = 0

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer

# voltea graficos y animaciones en caso de ser jugador 2
@export var voltear_personaje : bool = false 
@export var spriteframe : SpriteFrames # Cambia sprites de personaje 
@export var nodo_botones : Node2D # Conecta los botones

@export var nombre_personaje : StringName

var frame_actual_de_animacion : int # Información debug

# Indicativo de la acción que se está realizando
var ESTADO_ACTUAL : StringName = "idle"

# Indica si es vulnerable o no en el frame actual
var PUEDE_SER_ATACADO : bool = true

# Indica si puede tomar input en el frame actual
var PUEDE_RECIBIR_INPUT : bool = true

var input_buffer : StringName = "vacio"
var ataque_buffer : StringName = "vacio"

# Debuggin 
func _process(_delta: float) -> void:
	actualizar_debug_info()

# Inicia parametros necesarios para la partida
func _ready() -> void:
	# Carga sprites del personaje
	sprite.sprite_frames = spriteframe

	# Cambia al estado inicial
	reset()

	# Voltea sprite del personaje si esta en la parte derecha de la pantalla
	if voltear_personaje:
		voltear_sprite()
	
	# Conecta los botones con las acciones del personaje
	if nodo_botones:
		var botones := nodo_botones.get_children()
		for boton in botones:
			boton.connect("boton_presionado", _on_boton_presionado)

#-----------------# Funciones que cambian el estado del personaje #-----------------#

func reset() -> void:
	ESTADO_ACTUAL = "idle"
	sprite.play("idle")

func set_estado(estado : StringName) -> void:
	ESTADO_ACTUAL = estado

func set_puede_ser_atacado(valor : bool) -> void:
	PUEDE_SER_ATACADO = valor

func set_puede_recibir_input(valor : bool) -> void:
	PUEDE_RECIBIR_INPUT = valor


#-----------------# Funciones para debug #-----------------#

# Actualiza textos en pantalla con información del personaje
func actualizar_debug_info() -> void:
	$Debug/Estado.text = ESTADO_ACTUAL
	$Debug/Atacado.text = "PUEDE SER ATACADO = " + str(PUEDE_SER_ATACADO).to_upper()
	$Debug/Input.text = "PUEDE RECIBIR INPUT = " + str(PUEDE_RECIBIR_INPUT).to_upper()
	$Debug/Salud.text = "Salud = " + str(salud)
	$Debug/Frame.text = "Frame = " + str(frame_actual_de_animacion)


#-----------------# Funciones que cambian sprites y animaciones #-----------------#

# Cambia animación del sprite según la acción a realizar
func play_animacion(accion : StringName) -> void:
	var animacion : StringName
	match accion:
		"ataque_debil":
			# elige una animacion de golpe random
			if randi_range(1, 2) == 1: 
				animacion = "ataque_debil_1"
			else:
				animacion = "ataque_debil_2"

		# Hay dos animaciones de esquivo según la posicion del personaje en pantalla
		"esquivar": 
			animacion = "esquivar"
			if voltear_personaje:
				animacion += "_volteado"
			
		_:
			# Las demás animaciones tienen el mismo nombre que las acciones
			animacion = accion
	
	# Reproduce la animación de la accion solicitada
	animation_player.play(animacion)

# Se explica solo
func voltear_sprite() -> void:
	sprite.flip_h = true # voltea sprite
	%Burbuja.voltear() # Voltea escudo burbuja

	# Ajusta la posicion de la burbuja para quedar más al centro del sprite
	$PosMitadSprite.position = Vector2(120, 0)


#-----------------# Funciones que se activan con signals #-----------------#

# Se activa cuando un boton es presionado, recibe texto del boton
func _on_boton_presionado(nombre_accion : StringName) -> void:
	input_buffer = nombre_accion

# Devuelve al estado inicial cuando se acaba una animación
func _on_sprite_animation_finished() -> void:
	reset()

# Solo se procesa la logica del juego con cada cambio de frame
func _on_frame_changed() -> void:
	
	procesar_input_buffer()
	procesar_ataque_buffer()
	borrar_buffers()

	# Debugging
	frame_actual_de_animacion += 1
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

# Al ser atacado un personaje guarda el ataque recibido en el buffer
func _on_personaje_atacado(tipo_ataque : StringName) -> void:
	ataque_buffer = tipo_ataque

# Reinicia conteo de frames - Debugging
func _on_player_animation_changed(_nombre_animacion : String) -> void:
	frame_actual_de_animacion = 1

func _on_poder_recibido(_poder : int) -> void:
	if (poder + _poder) > PODER_MAXIMO:
		poder = PODER_MAXIMO
	elif (poder + _poder) < 0:
		poder = 0
	else:
		poder += _poder

func _on_salud_recibida(_salud : int) -> void:
	if (salud + _salud) > SALUD_MAXIMA:
		poder = SALUD_MAXIMA
	elif (salud + _salud) < 0:
		salud = 0
		emit_signal("salud_acabada")
	else:
		salud += _salud


#-----------------# Funciones que procesan los buffers #-----------------#

# Toma la acción solicitada y activa animación, de poderse
func procesar_input_buffer() -> void:
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

# Toma el ataque recibido y calcula la reaccion y el daño, de poderse
func procesar_ataque_buffer() -> void:
	match ataque_buffer:

		"ataque_debil":
			if ESTADO_ACTUAL == "bloquear":
				emit_signal("ha_bloqueado")

			elif ESTADO_ACTUAL == "esquivar" and not PUEDE_SER_ATACADO:
				emit_signal("ha_esquivado")

			else:
				_on_salud_recibida(-20)
				_on_poder_recibido(-10)
				play_animacion("herido")

		"ataque_fuerte":
			if ESTADO_ACTUAL == "esquivar" and not PUEDE_SER_ATACADO:
				emit_signal("ha_esquivado")

			elif ESTADO_ACTUAL == "bloquear":
				emit_signal("escudo_roto")
				play_animacion("herido")
				_on_salud_recibida(-10)

			else:
				_on_salud_recibida(-30)
				_on_poder_recibido(-20)
				play_animacion("herido")
		_:
			pass

# Reinicia los buffers
func borrar_buffers() -> void:
	input_buffer = "vacio"
	ataque_buffer = "vacio"

#-----------------# Funciones que controlan la ejecucion del personaje #-----------------#

# Pausa la animacion, como la logica se procesa con cada cambio de frame
# pausar la lógica un personaje es tan simple como pausar la animación.
func pausar() -> void:
	sprite.pause()
	animation_player.pause()

# Reanuda animación, por ende, la ejecución
func reanudar() -> void:
	sprite.play()
	animation_player.play()

# Emite señal de ataque
func atacar() -> void:
	ha_atacado.emit(ESTADO_ACTUAL)

# Inicia animación de escudo roto, no he podido abstraer esta función
# fuera del personaje ya que funciona de forma muy específica.
func romper_escudo() -> void:
	%Burbuja.romper_escudo()