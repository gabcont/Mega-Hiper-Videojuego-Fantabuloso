extends Control

# Diccionario que mapea los botones a los recursos SpriteFrames (agreguen aca las rutas a los sprites)
var boton_a_sprite = {
	"Knuckles": preload("res://juego/gameplay/escenas/personajes/knuckles.tres"),
	"Kirby": preload("res://juego/gameplay/escenas/personajes/kirby.tres"),
}

# Referencias a los AnimatedSprite2D de los jugadores
@onready var jugador1_sprite = $MenuContainer/MenuButtonsMargin/MenuButtonsContainer/HBoxContainer/jugador1_sprite
@onready var jugador2_sprite = $MenuContainer/MenuButtonsMargin/MenuButtonsContainer/HBoxContainer/jugador2_sprite

# Referencias a los Labels de los jugadores
@onready var jugador1_label = $VBoxContainer/Label2
@onready var jugador2_label = $VBoxContainer/Label

# Variable para identificar al jugador activo
var jugador_activo = 1  # Comienza con el Jugador 1

func _ready():
	# Accede al GridContainer
	jugador1_sprite.play()
	jugador2_sprite.play()
	var grid_container = $MenuContainer/MenuButtonsMargin/MenuButtonsContainer/HBoxContainer/GridContainer

	# Verifica que el GridContainer existe
	if grid_container:
		# Recorre todos los hijos de GridContainer (en este caso, los ColorRect)
		for color_rect in grid_container.get_children():
			# Asegúrate de que sean nodos tipo ColorRect
			if color_rect is ColorRect:
				# Recorre los hijos de cada ColorRect buscando botones
				for boton in color_rect.get_children():
					if boton is TextureButton:  
						# Crea un Callable y conecta la señal "pressed" pasando el nombre como parámetro
						boton.connect("pressed", Callable(self, "_on_boton_presionado").bind(boton.name))
	else:
		print("Error: No se encontró el nodo GridContainer.")


func _on_boton_presionado(button_name):
	print("\nSE ACABA DE PRESIONAR> Botón presionado: ", button_name)  
	
	# Cambiar el texto del Label dependiendo del jugador activo
	if jugador_activo == 1:
		jugador1_label.text = button_name
	elif jugador_activo == 2:
		jugador2_label.text = button_name
	
	# Verifica si el botón tiene un sprite asociado en el diccionario
	if boton_a_sprite.has(button_name):
		var spriteframe = boton_a_sprite[button_name]
		
		# Cambia el sprite según el jugador activo
		if jugador_activo == 1:
			cambiar_sprite(jugador1_sprite, spriteframe, false)  
		elif jugador_activo == 2:
			cambiar_sprite(jugador2_sprite, spriteframe, true)  


func cambiar_sprite(sprite_node, spriteframe, voltear):
	sprite_node.frames = spriteframe
	sprite_node.flip_h = voltear  # Voltear sprite si corresponde
	sprite_node.play("idle")  # Animación predeterminada

# Método para alternar el jugador activo
func seleccionar_jugador():
	jugador_activo = 1 if jugador_activo == 2 else 2
	#cuando se seleccione por segunda vez, guardar sprite y pasarlo a la escena partida
