extends LoadingScreen

signal faded_out
@onready var anim_player : AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	if anim_player:
		anim_player.connect("animation_finished", _on_animation_finished)
	$ColorRect.show()
	anim_player.play("fade_in")

func _on_animation_finished(anim_name:StringName) -> void:
	if anim_name == "fade_out":
		faded_out.emit()
	
func _load_next_scene():
	if _changing_to_next_scene:
		return
	_changing_to_next_scene = true
	anim_player.play("fade_out")
	await faded_out
	SceneLoader.call_deferred("change_scene_to_resource")
