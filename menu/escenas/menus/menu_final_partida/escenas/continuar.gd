extends Button

# Ruta a la escena que quieres cargar
var escena_juego := "res://menu/escenas/menus/menu_personajes/escenas/menu_personajes.tscn"
var escena_menu := "res://menu/escenas/menus/menu_principal/menu_principal_con_animaciones.tscn"

func _ready():
	# Conecta la señal "pressed" a la función "on_button_pressed"
	pressed.connect(on_button_pressed)


func on_button_pressed():
	get_tree().paused = false
	if text == "CONTINUAR":
		# Cambia a la escena de destino
		SceneLoader.reload_current_scene()
	else:
		SceneLoader.load_scene(escena_juego)
	
	
