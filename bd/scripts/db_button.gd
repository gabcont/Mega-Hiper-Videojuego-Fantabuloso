extends Button

# Ruta a la escena que quieres cargar
@export var path_escena_destino: String

func _ready():
	# Conecta la señal "pressed" a la función "on_button_pressed"
	pressed.connect(on_button_pressed)

func on_button_pressed():
	# Cambia a la escena de destino
	SceneLoader.load_scene(path_escena_destino)
