extends TextureButton

var color_original = modulate
var opacidad_hover = Color(0.7, 0.7, 0.7, 1) # Color blanco con opacidad del 70%
var sonido_hover = preload("res://menu-escenarios/assets/escenario_hover.mp3")
var reproductor_sonido = AudioStreamPlayer.new()
@export var escena_destino: PackedScene

func _ready():
	add_child(reproductor_sonido)
	reproductor_sonido.stream = sonido_hover

func _on_mouse_entered():
	modulate = opacidad_hover
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	reproductor_sonido.play()

func _on_mouse_exited():
	modulate = color_original
	mouse_default_cursor_shape = Control.CURSOR_ARROW
	
func _on_pressed():
	Transicion.transicion()
	await Transicion.on_transition_finished
	get_tree().change_scene_to_packed(escena_destino)
	
