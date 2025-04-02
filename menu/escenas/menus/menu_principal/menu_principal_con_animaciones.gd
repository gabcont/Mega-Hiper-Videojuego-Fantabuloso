extends MainMenu

@export var path_escena_cambiar_usuario : String

var animation_state_machine : AnimationNodeStateMachinePlayback

@export var estadisticas_packed_scene : PackedScene
@export var modos_juego_packed_scene : PackedScene

var estadisticas_scene : Control
var modo_juego_escene : Control

var popup_open


func intro_done():
	animation_state_machine.travel("OpenMainMenu")

func _is_in_intro():
	return animation_state_machine.get_current_node() == "Intro"

func _event_is_mouse_button_released(event : InputEvent):
	return event is InputEventMouseButton and not event.is_pressed()

func _event_skips_intro(event : InputEvent):
	return event.is_action_released("ui_accept") or \
		event.is_action_released("ui_select") or \
		event.is_action_released("ui_cancel") or \
		_event_is_mouse_button_released(event)

func _open_sub_menu(menu):
	super._open_sub_menu(menu)
	animation_state_machine.travel("OpenSubMenu")

func _close_sub_menu():
	super._close_sub_menu()
	animation_state_machine.travel("OpenMainMenu")

func _input(event):
	if _is_in_intro() and _event_skips_intro(event):
		intro_done()
		return
	if event.is_action_released("ui_cancel"):
		if sub_menu:
			_close_sub_menu()
		elif popup_open != null:
			close_popup()
		else:
			quit_game()
	if event.is_action_released("ui_accept") and get_viewport().gui_get_focus_owner() == null:
		%MenuButtonsBoxContainer.focus_first()

func _ready():
	super._ready()
	_setup_estadisticas()
	_setup_modo_juego()
	animation_state_machine = $MenuAnimationTree.get("parameters/playback")

func _on_continue_game_button_pressed():
	load_game_scene()

func _setup_estadisticas():
	if estadisticas_packed_scene == null:
		%EstadisticasButton.hide()
	else:
		estadisticas_scene = estadisticas_packed_scene.instantiate()
		estadisticas_scene.hide()
		%EstadisticasContainer.call_deferred("add_child", estadisticas_scene)

func _on_estadisticas_button_pressed() -> void:
	_open_sub_menu(estadisticas_scene)

func _setup_modo_juego() -> void:
	if modos_juego_packed_scene == null:
		%NewGameButton.hide()
	else:
		modo_juego_escene = modos_juego_packed_scene.instantiate()
		modo_juego_escene.hide()
		%ModosJuegoContainer.call_deferred("add_child", modo_juego_escene)

func _on_cambiar_usuario_button_pressed() -> void:
	SceneLoader.load_scene(path_escena_cambiar_usuario)

func _on_new_game_button_pressed() -> void:
	%ModosJuegoContainer.show()
	_open_sub_menu(modo_juego_escene)

func quit_game() -> void:
	%ConfirmExit.popup_centered()
	popup_open = %ConfirmExit

func close_popup():
	if popup_open != null:
		popup_open.hide()
		popup_open = null

func _on_confirm_exit_confirmed() -> void:
	get_tree().quit()
