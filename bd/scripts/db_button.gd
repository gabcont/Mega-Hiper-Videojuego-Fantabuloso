extends Button

# Ruta a la escena que quieres cargar
@export var escena_destino: PackedScene

func _ready():
	# Conecta la señal "pressed" a la función "on_button_pressed"
	pressed.connect(on_button_pressed)

func on_button_pressed():
	# Cambia a la escena de destino
	Transicion.transicion()
	await Transicion.on_transition_finished
	get_tree().change_scene_to_packed(escena_destino)
