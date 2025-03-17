extends Sprite2D

@export var subviewport_a_pixelar : SubViewport

func _ready():
    if material is ShaderMaterial and subviewport_a_pixelar != null:
        material.set_shader_parameter("viewport_texture", subviewport_a_pixelar.get_texture())

func _process(_delta: float) -> void:
    material.set_shader_parameter("viewport_texture", subviewport_a_pixelar.get_texture())