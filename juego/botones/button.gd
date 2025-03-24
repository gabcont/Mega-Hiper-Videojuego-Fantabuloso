extends Button

@export var accion_activada : StringName
@export var input_key : StringName	

@export var icono : Texture2D
@export var icono_presionado : Texture2D

var en_cooldown : bool = false

func _ready():
	connect("pressed", presionar_boton)
	var stylebox_boton = StyleBoxTexture.new()
	stylebox_boton.texture = icono
	add_theme_stylebox_override("normal", stylebox_boton)
	icon = icono

func presionar_boton(_activado : bool = true) -> void:
	if en_cooldown:
		print("boton: %s en cooldown" % input_key)
		return

	# Debug
	print("presionado %s ; " % input_key)
	print("emitido %s" % accion_activada)

	# Impide tomar input en cooldown
	en_cooldown = true

	# Cambia estado de boton
	set_pressed_no_signal(true)
	icon = icono_presionado

	# Activa accion del boton
	var input_event = InputEventAction.new()
	input_event.action = accion_activada
	Input.parse_input_event(input_event)

	# Cooldown
	await get_tree().create_timer(0.1).timeout

	# Devuelve a estado inicial
	set_pressed_no_signal(false)
	icon = icono
	en_cooldown = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(input_key):
		if not en_cooldown:
			presionar_boton()
		else:
			print("boton: %s en cooldown" % input_key)
