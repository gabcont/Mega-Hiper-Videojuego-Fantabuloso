extends Control

@export var path_siguiente_escena : String

# Diccionario que mapea los botones a los recursos SpriteFrames (agreguen aca las rutas a los sprites)
var nombre_a_spriteframe : Dictionary

var path_carpeta_personajes : String = "res://juego/personajes/assets/animaciones/"

# Referencias a los AnimatedSprite2D de los jugadores
@onready var jugador1_sprite = $MenuContainer/MenuButtonsMargin/MenuButtonsContainer/HBoxContainer/jugador1_sprite

# Referencias a los Labels de los jugadores
@onready var jugador1_label = $VBoxContainer/Label2

var personaje_jugador1 : String = ""

# Variable para identificar al jugador activo
var jugador_activo = 1  # Comienza con el Jugador 1

func _ready():
	# Accede al GridContainer
	jugador1_sprite.play()

	var grid_container = %GridPersonajes
	var carpeta_personajes : DirAccess = DirAccess.open(path_carpeta_personajes)
	carpeta_personajes.list_dir_begin()

	var personaje_actual = carpeta_personajes.get_next()
	while personaje_actual != "":
		var cuadro_color = ColorRect.new()
		cuadro_color.color = Color(randf(), randf(), randf(), 0.5)
		cuadro_color.custom_minimum_size = Vector2(100.0, 90.0)

		
		var boton_de_textura = TextureButton.new()
		boton_de_textura.ignore_texture_size = true
		boton_de_textura.stretch_mode = 0
		boton_de_textura.custom_minimum_size = Vector2(100.0, 90.0)
		boton_de_textura.position = Vector2(20.0, 0.0)
		boton_de_textura.mouse_default_cursor_shape = 2
		boton_de_textura.texture_filter = 1
		var spriteframes_personaje : SpriteFrames = load(path_carpeta_personajes + personaje_actual)
		boton_de_textura.texture_normal = spriteframes_personaje.get_frame_texture("idle", 0)
		boton_de_textura.name = personaje_actual.trim_suffix(".tres")

		nombre_a_spriteframe.set(personaje_actual.trim_suffix(".tres"), spriteframes_personaje)
		cuadro_color.add_child(boton_de_textura)
		grid_container.add_child(cuadro_color)
		boton_de_textura.connect("pressed", Callable(self, "_on_boton_presionado").bind(boton_de_textura.name))
		personaje_actual = carpeta_personajes.get_next()

func _on_boton_presionado(button_name):
	print("\nSE ACABA DE PRESIONAR> Botón presionado: ", button_name)  
	
	# Cambiar el texto del Label dependiendo del jugador activo
	if jugador_activo == 1:
		jugador1_label.text = button_name

	# Verifica si el botón tiene un sprite asociado en el diccionario
	if nombre_a_spriteframe.has(button_name):
		var spriteframe = nombre_a_spriteframe[button_name]
		
		# Cambia el sprite según el jugador activo
		if jugador_activo == 1:
			cambiar_sprite(jugador1_sprite, spriteframe, false)
			personaje_jugador1 = button_name  

func cambiar_sprite(sprite_node, spriteframe, voltear):
	sprite_node.frames = spriteframe
	sprite_node.flip_h = voltear  # Voltear sprite si corresponde
	sprite_node.play("idle")  # Animación predeterminada

# Método para alternar el jugador activo
func seleccionar_jugador():
	if personaje_jugador1 != "" :
		ConfigPartida.nombre_personaje_1 = personaje_jugador1
		Transicion.transicion()
		await Transicion.on_transition_finished
		get_tree().change_scene_to_file(path_siguiente_escena)

	jugador_activo = 1 
	#cuando se seleccione por segunda vez, guardar sprite y pasarlo a la escena partida
