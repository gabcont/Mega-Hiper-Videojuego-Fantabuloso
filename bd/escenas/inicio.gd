extends Control

@export var path_siguiente_escena : String
@export var packedscene_inicio_sesion : PackedScene
@export var packedscene_registro : PackedScene

var escena_inicio_sesion : Control
var escena_registro : Control

var sub_menu

func _ready():
	_setup_inicio_sesion()
	_setup_registro()

func _event_is_mouse_button_released(event : InputEvent):
	return event is InputEventMouseButton and not event.is_pressed()

func _input(event):
	if event.is_action_released("ui_cancel"):
		if sub_menu:
			_close_sub_menu()
		else:
			get_tree().quit()
	if event.is_action_released("ui_accept") and get_viewport().gui_get_focus_owner() == null:
		%MenuButtonsBoxContainer.focus_first()

func _open_sub_menu(menu : Control):
	sub_menu = menu
	if sub_menu:
		sub_menu.show()
		%BackButton.show()
		%MenuContainer.hide()

func _close_sub_menu():
	if sub_menu == null:
		return
	sub_menu.hide()
	sub_menu = null
	%BackButton.hide()
	%MenuContainer.show()

func _setup_inicio_sesion() -> void:
	if packedscene_inicio_sesion == null:
		%InicioButton.hide()
	else:
		escena_inicio_sesion = packedscene_inicio_sesion.instantiate()
		escena_inicio_sesion.connect("sesion_iniciada", _on_sesion_iniciada)
		escena_inicio_sesion.hide()
		%InicioContainer.call_deferred("add_child", escena_inicio_sesion)

func _setup_registro() -> void:
	if packedscene_registro == null:
		%RegistroButton.hide()
	else:
		escena_registro = packedscene_registro.instantiate()
		escena_registro.connect("usuario_registrado", _on_usuario_registrado)
		escena_registro.hide()
		%RegistroContainer.call_deferred("add_child", escena_registro)

func _on_registro_pressed() -> void:
	_open_sub_menu(escena_registro)

func _on_inicio_pressed() -> void:
	_open_sub_menu(escena_inicio_sesion)

func _on_back_button_pressed() -> void:
	_close_sub_menu()

func _on_sesion_iniciada() -> void:
	print("Sesion iniciada")
	cargar_siguiente_escena()

func _on_usuario_registrado() -> void:
	print("Usuario registrado")
	cargar_siguiente_escena()

func cargar_siguiente_escena() -> void:
	SceneLoader.load_scene(path_siguiente_escena)
