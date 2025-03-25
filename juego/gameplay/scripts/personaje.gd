class_name Personaje extends Node2D


signal ha_atacado(es_personaje_1 : bool, tipo_ataque : StringName)
signal ha_esquivado(es_personaje_1 : bool)
signal ha_bloqueado(es_personaje_1 : bool)
signal escudo_roto(es_personaje_1 : bool)

signal ataque_especial_activado(es_personaje_1 : bool)
signal salud_acabada(es_personaje_1 : bool)

const SALUD_MAXIMA : int = 400
var salud : int = SALUD_MAXIMA

const PODER_MAXIMO : int = 100
var poder : int = 10

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var menu_final = $"../../ReferenceRect"
@onready var statusLabel = $"../../ReferenceRect/Menu_final/CenterContainer/VBoxContainer/Label"


# voltea graficos y animaciones en caso de ser jugador 2
@export var es_personaje_1 : bool = false 
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

var input_action_ataque_debil = "ataque_debil"
var input_action_ataque_fuerte = "ataque_fuerte"
var input_action_esquivar = "esquivar"
var input_action_bloquear = "bloquear"
var sufijo_personaje : String = "_p1"

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
	if not es_personaje_1:
		sufijo_personaje = "_p2"
		voltear_sprite()
	
	input_action_ataque_debil += sufijo_personaje
	input_action_ataque_fuerte += sufijo_personaje
	input_action_esquivar += sufijo_personaje
	input_action_bloquear += sufijo_personaje

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action(input_action_ataque_debil):
		input_buffer = "ataque_debil"
	elif event.is_action(input_action_ataque_fuerte):
		input_buffer = "ataque_fuerte"
	elif event.is_action(input_action_esquivar):
		input_buffer = "esquivar"
	elif event.is_action(input_action_bloquear):
		input_buffer = "bloquear"


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
			if not es_personaje_1:
				animacion += "_volteado"

		"ataque_especial":
			animacion = "ataque_especial"
			if not es_personaje_1:
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

# Reinicia conteo de frames - Debugging
func _on_player_animation_changed(_nombre_animacion : String) -> void:
	frame_actual_de_animacion = 1

func cargar_poder(_poder : int) -> void:
	if (poder + _poder) > PODER_MAXIMO:
		poder = PODER_MAXIMO
	elif (poder + _poder) < 0:
		poder = 0
	else:
		poder += _poder

func cargar_salud(_salud : int) -> void:
	if (salud + _salud) > SALUD_MAXIMA:
		poder = SALUD_MAXIMA
	elif (salud + _salud) <= 0:
		salud = 0
		emit_signal("salud_acabada", es_personaje_1)
		menu_final.show()
		get_tree().paused = true
		statusLabel.text = "Jugador 2 gano" if es_personaje_1 else "Jugador 1 gano"
		var db = Db.conectar_base()
		var res = db.insert_row("partida",{"id_usuario":Db.usuario_id,"id_personaje_usado":1,"id_personaje_enfrentado":2,"victoria":not es_personaje_1,"duracion_en_sg":99-%Reloj.countdown_time})
		
		
			
		
	else:
		salud += _salud

# Al ser atacado un personaje guarda el ataque recibido en el buffer
func ataque_a_buffer(tipo_ataque : StringName) -> void:
	ataque_buffer = tipo_ataque

#-----------------# Funciones que procesan los buffers #-----------------#

# Toma la acción solicitada y activa animación, de poderse
func procesar_input_buffer() -> void:
	if PUEDE_RECIBIR_INPUT and input_buffer != "vacio":
		match ESTADO_ACTUAL:
			"ataque_fuerte":
				if input_buffer == "esquivar":
					# amague
					pass
				elif input_buffer == "ataque_debil" and poder == PODER_MAXIMO:
					cargar_poder(-100)
					emit_signal("ataque_especial_activado", es_personaje_1)
					play_animacion("ataque_especial")
			_:
				play_animacion(input_buffer)

# Toma el ataque recibido y calcula la reaccion y el daño, de poderse
func procesar_ataque_buffer() -> void:
	match ataque_buffer:

		"ataque_debil":
			if ESTADO_ACTUAL == "bloquear":
				emit_signal("ha_bloqueado", es_personaje_1)

			elif ESTADO_ACTUAL == "esquivar" and not PUEDE_SER_ATACADO:
				emit_signal("ha_esquivado", es_personaje_1)

			else:
				cargar_salud(-20)
				cargar_poder(-10)
				play_animacion("herido")

		"ataque_fuerte":
			if ESTADO_ACTUAL == "esquivar" and not PUEDE_SER_ATACADO:
				emit_signal("ha_esquivado", es_personaje_1)

			elif ESTADO_ACTUAL == "bloquear":
				emit_signal("escudo_roto", es_personaje_1)
				play_animacion("herido")
				cargar_salud(-10)

			else:
				cargar_salud(-30)
				cargar_poder(-20)
				play_animacion("herido")
		
		"ataque_especial":
			if ESTADO_ACTUAL == "esquivar" and not PUEDE_SER_ATACADO:
				emit_signal("ha_esquivado", es_personaje_1)
			elif ESTADO_ACTUAL == "bloquear":
				emit_signal("escudo_roto", es_personaje_1)
				cargar_salud(-60)
				cargar_poder(-20)
				play_animacion("herido")
			else:
				cargar_salud(-70)
				cargar_poder(-20)
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
	ha_atacado.emit(es_personaje_1, ESTADO_ACTUAL)

# Inicia animación de escudo roto, no he podido abstraer esta función
# fuera del personaje ya que funciona de forma muy específica.
func romper_escudo() -> void:
	%Burbuja.romper_escudo()
