extends Button

# Ruta a la escena que quieres cargar
var escena_juego = load("res://gameplay/escenas/partida.tscn")
var escena_menu = load("res://menu-principal/escenas/menu_principal.tscn")

func _ready():
	# Conecta la señal "pressed" a la función "on_button_pressed"
	pressed.connect(on_button_pressed)

func on_button_pressed():
	Transicion.transicion_partida()
	await Transicion.on_transition_finished

	if text == "VOLVER A JUGAR":
		# Cambia a la escena de destino
		get_tree().change_scene_to_file(escena_juego.resource_path)
	else:
		get_tree().change_scene_to_file(escena_menu.resource_path)
	
	
