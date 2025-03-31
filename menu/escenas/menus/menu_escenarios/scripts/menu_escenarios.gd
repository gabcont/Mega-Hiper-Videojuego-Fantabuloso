extends Control

@export var path_siguiente_escena : String

# Diccionario único que mapea los botones a las rutas de las escenas de fondo parallax
var boton_a_escena = {
	"Caricuao": preload("res://juego/Fondo/escenas/Caricuao.tscn"),
	"Helado": preload("res://juego/Fondo/escenas/Helado.tscn"),
	"Callejon": preload("res://juego/Fondo/escenas/Callejon.tscn"),
	"Ciudad": preload("res://juego/Fondo/escenas/Ciudad.tscn"),
	"Restaurant": preload("res://juego/Fondo/escenas/Restaurant.tscn"),
	"Estatua": preload("res://juego/Fondo/escenas/Estatua.tscn"),
	"Plaza": preload("res://juego/Fondo/escenas/Plaza.tscn"),
	"Pizarra": preload("res://juego/Fondo/escenas/Pizarra.tscn"),
	"Cancha": preload("res://juego/Fondo/escenas/Cancha.tscn")
}

# Referencias a los nodos del árbol
@onready var ContenedorFondo = $Control/ContenedorFondo
@onready var label_estado = $MenuContainer/SubTitleMargin/SubTitleContainer/subtitulo

# Variable para almacenar el botón seleccionado
var boton_seleccionado : TextureButton = null

func _ready():
	# Acceder al GridContainer
	var grid_container = $MenuContainer/MenuButtonsMargin/MenuButtonsContainer/HBoxContainer/GridContainer

	# Verifica que el GridContainer existe
	if grid_container:
		# Recorre todos los botones en el GridContainer
		for boton in grid_container.get_children():
			if boton is TextureButton:
				# Conecta la señal "pressed" al método de manejo de botones
				boton.connect("pressed", Callable(self, "_on_boton_presionado").bind(boton))
				print("Botón conectado:", boton.name)

				# Asigna el ShaderMaterial al botón
				boton.material = ShaderMaterial.new()
				boton.material.shader = load("res://menu/escenas/menus/menu_escenarios/escenas/MenuEscenarios.gdshader") # Ruta al shader
				boton.material.set_shader_parameter("overlay_color", Color(1, 0, 0, 0)) # Inicializa la opacidad a 0
	else:
		print("Error: No se encontró el nodo GridContainer.")

# Método que se ejecuta al presionar un botón
func _on_boton_presionado(boton):
	print("¡El botón fue presionado correctamente:", boton.name)

	# Cambiar el texto del Label
	if label_estado:
		label_estado.text = boton.name
		print("Texto del Label actualizado a:", label_estado.text)
	else:
		print("Error: No se encontró el LabelEstado.")

	# Verifica si el botón tiene una escena asociada
	if boton_a_escena.has(boton.name):
		cargar_fondo(boton_a_escena[boton.name])
		print("SI tiene una escena")
	else:
		print("Error: No hay ninguna escena asociada a este botón:", boton.name)

	# Aplica el efecto de sombra roja
	aplicar_sombra_roja(boton)

# Función para cargar la escena seleccionada
func cargar_fondo(ruta_escena):
	# Eliminar el fondo anterior si existe
	if ContenedorFondo.get_child_count() > 0:
		print("Eliminando fondo anterior...")
		ContenedorFondo.get_child(0).queue_free()
		print("Fondo anterior eliminado.")

	# Instanciar la nueva escena
	print("Instanciando nueva escena...")
	var nueva_escena = ruta_escena.instantiate()
	ContenedorFondo.add_child(nueva_escena)
	print("Escena añadida al ContenedorFondo.")

func _on_seleccionar_pressed() -> void:
	ConfigPartida.escenario_seleccionado = label_estado.text
	Transicion.transicion()
	await Transicion.on_transition_finished
	get_tree().change_scene_to_file(path_siguiente_escena)

# Función para aplicar la sombra roja al botón
func aplicar_sombra_roja(boton):
	if boton is TextureButton:
		# Remueve la sombra del botón seleccionado anteriormente
		if boton_seleccionado != null:
			boton_seleccionado.material.set_shader_parameter("overlay_color", Color(1, 0, 0, 0))

		boton.material.set_shader_parameter("overlay_color", Color(1, 0, 0, 0.2)) # Aplica la sombra roja
		boton_seleccionado = boton # Actualiza el botón seleccionado
