extends Button

@export var accion_activada : StringName
@export var input_key : StringName	

var en_cooldown : bool = false

func _ready():
	connect("pressed", presionar_boton)

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

	# Activa accion del boton
	var input_event = InputEventAction.new()
	input_event.action = accion_activada
	Input.parse_input_event(input_event)

	# Cooldown
	await get_tree().create_timer(0.1).timeout

	# Devuelve a estado inicial
	set_pressed_no_signal(false)
	en_cooldown = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(input_key):
		if not en_cooldown:
			presionar_boton()
		else:
			print("boton: %s en cooldown" % input_key)
