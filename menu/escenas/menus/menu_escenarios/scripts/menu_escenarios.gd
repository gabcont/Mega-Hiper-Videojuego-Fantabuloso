extends Control

@export var path_siguiente_escena : String

# Diccionario único que mapea los botones a las rutas de las escenas de fondo parallax
var boton_a_escena = {
	"Lugar1": preload("res://juego/Fondo/escenas/Caricuao.tscn"), 
}

# Referencias a los nodos del árbol
@onready var ContenedorFondo = $Control/ContenedorFondo
@onready var label_estado = $MenuContainer/SubTitleMargin/SubTitleContainer/subtitulo


func _ready():
	# Acceder al GridContainer
	var grid_container = %EscenariosGrid
	
	# Verifica que el GridContainer existe
	if grid_container:
		# Recorre todos los botones en el GridContainer
		for boton in grid_container.get_children():
			if boton is TextureButton:  # Verifica que el nodo es del tipo correcto
				# Conecta la señal "pressed" al método de manejo de botones
				boton.texture_focused = apply_lighten_filter(boton.texture_normal)
				boton.connect("pressed", Callable(self, "_on_boton_presionado").bind(boton.name))
				print("Botón conectado:", boton.name)  # Depuración para confirmar conexión
	else:
		print("Error: No se encontró el nodo GridContainer.")

# Método que se ejecuta al presionar un botón
func _on_boton_presionado(button_name):
	print("¡El botón fue presionado correctamente:", button_name)
	
	# Cambiar el texto del Label
	if label_estado:
		label_estado.text = button_name
		print("Texto del Label actualizado a:", label_estado.text)
	else:
		print("Error: No se encontró el LabelEstado.")

	# Verifica si el botón tiene una escena asociada
	if boton_a_escena.has(button_name):
		cargar_fondo(boton_a_escena[button_name])
		print("SI tiene una escena")
	else:
		print("Error: No hay ninguna escena asociada a este botón:", button_name)

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
	ConfigPartida.limpiar_queue()
	ConfigPartida.agregar_a_partida_queue(ConfigPartida.nombre_personaje_1, ConfigPartida.nombre_personaje_2, ConfigPartida.escenario_seleccionado)
	SceneLoader.load_scene(ConfigPartida.path_partida)

func apply_lighten_filter(original_texture: Texture2D, lighten_amount: float = 0.3) -> Texture2D:
	lighten_amount = clamp(lighten_amount, 0.0, 1.0)
	
	var image := original_texture.get_image()
	var filtered_image := Image.create(image.get_width(), image.get_height(), false, Image.FORMAT_RGBA8)
	
	for x in image.get_width():
		for y in image.get_height():
			var pixel = image.get_pixel(x, y)
			if pixel.a > 0:
				# Aclarar el color sin convertirlo completamente a blanco
				var new_pixel = Color(
					pixel.r + (1.0 - pixel.r) * lighten_amount,
					pixel.g + (1.0 - pixel.g) * lighten_amount,
					pixel.b + (1.0 - pixel.b) * lighten_amount,
					pixel.a
				)
				filtered_image.set_pixel(x, y, new_pixel)
			else:
				filtered_image.set_pixel(x, y, Color(0, 0, 0, 0))
	
	return ImageTexture.create_from_image(filtered_image)