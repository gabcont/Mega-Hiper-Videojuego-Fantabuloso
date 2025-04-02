extends MainMenu

var animation_state_machine : AnimationNodeStateMachinePlayback

@export var estadisticas_packed_scene : PackedScene
var estadisticas_scene

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
	super._input(event)

func _ready():
	super._ready()
	_setup_estadisticas()
	animation_state_machine = $MenuAnimationTree.get("parameters/playback")

func _on_continue_game_button_pressed():
	load_game_scene()

func _setup_estadisticas():
	if estadisticas_packed_scene == null:
		%CreditsButton.hide()
	else:
		estadisticas_scene = estadisticas_packed_scene.instantiate()
		estadisticas_scene.hide()
		%EstadisticasContainer.call_deferred("add_child", estadisticas_scene)

func _on_estadisticas_button_pressed() -> void:
	_open_sub_menu(estadisticas_scene)
